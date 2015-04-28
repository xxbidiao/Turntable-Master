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

for(var i = realObjectsStartingAt; i < allEvents.length; i++)
{
  var thisOneStillNeedConsideration = 0; //false
  var time = measureSize * (allEvents[i].measure+allEvents[i].position)- offset;
  if(time-lastTime < 0.01)
  {
    //simply skip this one
    objectSkipped++;
  }
  else if(time-lastTime < measureSize / 7.999)
  {
    //add this note into the queue
    tempLongEvents.push(allEvents[i]);
  }
  else
  {
    //finish this note
    var count = tempLongEvents.length;
    if(count == 1)
    {
      var theTime = measureSize * (tempLongEvents[0].measure+tempLongEvents[0].position)- offset;
      var singleObject = {};
      singleObject.objectType = 0;
      singleObject.objectSubType = Math.floor(Math.random() * (2));;
      singleObject.objectPosition={};
      singleObject.objectPosition["SingleNotePosition"]=Math.floor(Math.random() * (8));;
      singleObject.startingTime=theTime;
      objects.push(singleObject);
      objectCreated++;    
    }
    else
    {
      var firstTime = measureSize * (tempLongEvents[0].measure+tempLongEvents[0].position)- offset;
      var longObject = {};
      longObject.objectType = 1;
      longObject.objectSubType = Math.floor(Math.random() * (2));
      longObject.objectPosition={};
      longObject.objectPosition["LongNoteTotalNodeCount"]=count;
      var ii;
      for(ii = 0; ii < count; ii++)
      {
        var thisNoteTime = measureSize*(tempLongEvents[ii].measure+tempLongEvents[ii].position)- offset;
        var deltaTime = thisNoteTime - firstTime;
        var labelNumber = ii+1;
        var possiblePosition = (tempLongEvents[ii].channel-10)%8;
        longObject.objectPosition["LongNoteNodePosition"+labelNumber] = Math.floor(Math.random() * (5));
        longObject.objectPosition["LongNoteNodeTime"+labelNumber] = deltaTime;
      }
      longObject.startingTime=firstTime;
      objects.push(longObject);
      objectCreated++;    

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

