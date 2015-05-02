var tools = require('./bms');

if (process.argv.length < 3) {
  console.log('[Fail]BMS2TCF Usage: node ' + process.argv[1] + ' FILENAME');
  process.exit(1);
}
console.log('[Log]BMS2TCF version 0.0.2');
// Read the file and print its contents.
var fs = require('fs')
  , filename = process.argv[2];
var bmsdata;
console.log('[Log]' + filename + ' is going to be parsed.');
bmsdata = fs.readFileSync(filename, 'utf8');
console.log('[Log]' + filename + ' is loaded from the disk.');

parsedResult = tools.parse(bmsdata);

fs.writeFileSync('intermediate',JSON.stringify(parsedResult));

var parsedheaders = parsedResult.headers;
var allEvents = parsedResult.events;


var chartInfo = {};
var objects=[];
var BPM = 0;

for (var key in parsedheaders) {
  //console.log(key+" "+parsedResult.headers[key]);
  if(key == "title")
  {
    chartInfo["title"]=parsedheaders[key];
  }
  if(key == "bpm")
  {
    chartInfo["bpm"]=parsedheaders[key];
    BPM = parseFloat(parsedheaders[key]);
  }
  if(key == "playlevel")
  {
    chartInfo["Difficulty"]=parsedheaders[key];
  }
};

var measureSize = 240 / BPM; //assuming 4/4

var offset = 0;

var realObjectsStartingAt = 0;

if(allEvents[0].channel > 100)
{
  offset = measureSize * (allEvents[0].measure+allEvents[0].position);
  console.log("[Log]Possible non-keysound chart. Setting offset at "+offset);
  realObjectsStartingAt = 1;
  var bgmfile = parsedResult.keysounds[allEvents[0].value];
  console.log("[Log]Possible BGM file name:"+bgmfile);
  var extension = "mp3" 
  var bgmfilename = bgmfile.split(".")[0];
  chartInfo["BGMExtension"] = extension;
  chartInfo["BGMFilename"] = bgmfilename; 
}

var objectCreated = 0;
var objectSkipped = 0;
var lastTime = 0;

var debug = 1;

allEvents.sort(function(a,b){return (a.measure+a.position-b.measure-b.position)});

  var tempLongEvents = [];

var haveAlreadyPutAnotherSingleNote = false;
var pendingNoteAdded = false;
var pendingExtraNote = {};
var longNoteJustFinished = false;
for(var i = realObjectsStartingAt; i < allEvents.length; i++)
{
  var thisOneStillNeedConsideration = 0; //false
  var time = measureSize * (allEvents[i].measure+allEvents[i].position)- offset;
  if(time-lastTime < 0.01)
  {
    //simply skip this one
    if(!haveAlreadyPutAnotherSingleNote)
    {
      var theTime = time;
      var singleObject = {};
      singleObject.objectType = 0;
      singleObject.objectSubType = 1;
      singleObject.objectPosition={};
      singleObject.objectPosition["SingleNotePosition"]=2;
      singleObject.startingTime=theTime;
      pendingExtraNote = singleObject;
      //objects.push(singleObject);
      //objectCreated++;
      haveAlreadyPutAnotherSingleNote = true;
      pendingNoteAdded = false;      
    }
    else
    objectSkipped++;
  }
  else if(time-lastTime < measureSize / 7.999)
  {
    longNoteJustFinished = false;
    haveAlreadyPutAnotherSingleNote = false;
    //add this note into the queue
    tempLongEvents.push(allEvents[i]);
  }
  else
  {
    haveAlreadyPutAnotherSingleNote = false;
    //finish this note
    var count = tempLongEvents.length;
    if(count == 1)
    {
      var theTime = measureSize * (tempLongEvents[0].measure+tempLongEvents[0].position)- offset;
      var singleObject = {};
      singleObject.objectType = 0;
      singleObject.objectSubType = 0
      singleObject.objectPosition={};
      singleObject.objectPosition["SingleNotePosition"]=2;
      singleObject.startingTime=theTime;
      objects.push(singleObject);
      objectCreated++;
      if(!pendingNoteAdded)   
      {
         objects.push(pendingExtraNote);
        objectCreated++;
        pendingNoteAdded = true;       
      }
      longNoteJustFinished = false;
    
    }
    else
    {
      var firstTime = measureSize * (tempLongEvents[0].measure+tempLongEvents[0].position)- offset;
      var longObject = {};
      longObject.objectType = 1;
      longObject.objectSubType = 1;
      longObject.objectPosition={};
      longObject.objectPosition["LongNoteTotalNodeCount"]=count;
      var ii;
      var lastPosition = 0;
      var lastChannel = 0;
      for(ii = 0; ii < count; ii++)
      {
        var thisNoteTime = measureSize*(tempLongEvents[ii].measure+tempLongEvents[ii].position)- offset;
        var deltaTime = thisNoteTime - firstTime;
        var labelNumber = ii+1;
        var chan = (tempLongEvents[ii].channel);
        var thisObjPosition;
        if(chan >= lastChannel)
        {
          thisObjPosition = lastPosition + 1;

          if(thisObjPosition > 5) thisObjPosition = 5;
                    lastPosition = thisObjPosition;

        }
        else
        {
          thisObjPosition = lastPosition - 1;

          if(thisObjPosition < 0) thisObjPosition = 0;
                    lastPosition = thisObjPosition;
        }

        lastChannel = chan;
        longObject.objectPosition["LongNoteNodePosition"+labelNumber] = thisObjPosition;
        longObject.objectPosition["LongNoteNodeTime"+labelNumber] = deltaTime;
        
      }
      longObject.startingTime=firstTime;
      objects.push(longObject);
      objectCreated++;
      longNoteJustFinished = true;
      pendingExtraNote = {};
      pendingNoteAdded = true; //for safety issues    

    }
    //current one starts a new note
    tempLongEvents = [];
    tempLongEvents.push(allEvents[i]);

  }


  lastTime = time;
}
console.log("[Log]"+objectCreated+" Objects created, "+objectSkipped+" Objects skipped");



objects.sort(function(a,b){return (a.startingTime-b.startingTime)});

var result = {};
result.chartInfo = chartInfo;
result.objects = objects;
//console.log(JSON.stringify(result));
fs.writeFileSync('result.tcf',JSON.stringify(result));

