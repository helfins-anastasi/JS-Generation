// From http://mkweb.bcgsc.ca/circos/guide/tables/
var matrix = [
  [11975,  5871, 8916, 2868],
  [ 1951, 10048, 2060, 6171],
  [ 8010, 16145, 8090, 8045],
  [ 1013,   990,  940, 6907]
];

var chord = d3.layout.chord()
    .padding(.05)
    .sortSubgroups(d3.descending)
    .matrix(matrix);

var width = 960,
    height = 500,
    innerRadius = Math.min(width, height) * .41,
    outerRadius = innerRadius * 1.1;

var fill = d3.scale.ordinal()
    .domain(d3.range(4))
    .range(["#000000", "#FFDD89", "#957244", "#F26223"]);

var svg = d3.select("body").append("svg")
    .attr("width", width)
    .attr("height", height)
  .append("g")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

svg.append("g").selectAll("path")
    .data(chord.groups)
  .enter().append("path")
    .style("fill", function(d) { return fill(d.index); })
    .style("stroke", function(d) { return fill(d.index); })
    .attr("d", d3.svg.arc().innerRadius(innerRadius).outerRadius(outerRadius))
    .on("mouseover", fade(.1))
    .on("mouseout", fade(1));

var ticks = svg.append("g").selectAll("g")
    .data(chord.groups)
  .enter().append("g").selectAll("g")
    .data(groupTicks)
  .enter().append("g")
    .attr("transform", function(d) {
      return "rotate(" + (d.angle * 180 / Math.PI - 90) + ")"
          + "translate(" + outerRadius + ",0)";
    });

ticks.append("line")
    .attr("x1", 1)
    .attr("y1", 0)
    .attr("x2", 5)
    .attr("y2", 0)
    .style("stroke", "#000");

ticks.append("text")
    .attr("x", 8)
    .attr("dy", ".35em")
    .attr("transform", function(d) { return d.angle > Math.PI ? "rotate(180)translate(-16)" : null; })
    .style("text-anchor", function(d) { return d.angle > Math.PI ? "end" : null; })
    .text(function(d) { return d.label; });

svg.append("g")
    .attr("class", "chord")
  .selectAll("path")
    .data(chord.chords)
  .enter().append("path")
    .attr("d", d3.svg.chord().radius(innerRadius))
    .style("fill", function(d) { return fill(d.target.index); })
    .style("opacity", 1);

// Returns an array of tick angles and labels, given a group.
function groupTicks(d) {
  var k = (d.endAngle - d.startAngle) / d.value;
  return d3.range(0, d.value, 1000).map(function(v, i) {
    return {
      angle: v * k + d.startAngle,
      label: i % 5 ? null : v / 1000 + "k"
    };
  });
}

// Returns an event handler for fading a given chord group.
function fade(opacity) {
  return function(g, i) {
    svg.selectAll(".chord path")
        .filter(function(d) { return d.source.index != i && d.target.index != i; })
      .transition()
        .style("opacity", opacity);
  };
}

var margin = {top: 10, right: 50, bottom: 20, left: 50},
    width = 120 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var min = Infinity,
    max = -Infinity;

var chart = d3.box()
    .whiskers(iqr(1.5))
    .width(width)
    .height(height);

d3.csv("morley.csv", function(error, csv) {
  var data = [];

  csv.forEach(function(x) {
    var e = Math.floor(x.Expt - 1),
        r = Math.floor(x.Run - 1),
        s = Math.floor(x.Speed),
        d = data[e];
    if (!d) d = data[e] = [s];
    else d.push(s);
    if (s > max) max = s;
    if (s < min) min = s;
  });

  chart.domain([min, max]);

  var svg = d3.select("body").selectAll("svg")
      .data(data)
    .enter().append("svg")
      .attr("class", "box")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.bottom + margin.top)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
      .call(chart);

  setInterval(function() {
    svg.datum(randomize).call(chart.duration(1000));
  }, 2000);
});

function randomize(d) {
  if (!d.randomizer) d.randomizer = randomizer(d);
  return d.map(d.randomizer);
}

function randomizer(d) {
  var k = d3.max(d) * .02;
  return function(d) {
    return Math.max(min, Math.min(max, d + k * (Math.random() - .5)));
  };
}

// Returns a function to compute the interquartile range.
function iqr(k) {
  return function(d, i) {
    var q1 = d.quartiles[0],
        q3 = d.quartiles[2],
        iqr = (q3 - q1) * k,
        i = -1,
        j = d.length;
    while (d[++i] < q1 - iqr);
    while (d[--j] > q3 + iqr);
    return [i, j];
  };
}

