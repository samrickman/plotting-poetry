/*

*/

var G = new jsnx.DiGraph();


for(let i = 0; i < node_groups.length; i++){
    G.addNodesFrom(node_groups[i], {group:i});
    
}

G.addEdgesFrom(spreadsheet_edges);

var color = d3.scale.category20();


// helper method to find and style SVG node elements
function highlight_nodes(nodes, on) {
    nodes.forEach(function(n) {
        d3.select('#node-' + n.replace(/\s/g, '')).style('fill', function(d) {
            return on ? '#FF0000' : color(d.data.group);
            
        });

    });
}


jsnx.draw(G, {
    element: '#canvas',
    withLabels: 'true',
    panZoom: {
        enabled: true, 
        scale: true},
    layoutAttr: {
        charge: -1800,
        linkDistance: 200
    },
    nodeAttr: {
        r: 10,
        title: function(d) { return d.label;},
        id: function(d) {
            return 'node-' + d.node.replace(/\s/g, '');
        }
        
    },
    nodeStyle: {
        fill: function(d) { 
            return color(d.data.group); 
        },
        stroke: 'none',
        opacity: 0.6,
    },
    edgeStyle: {
        fill: '#0',
        'stroke-width': 5
    },
    labelStyle: {
        fill: '#ffffff'
    },
    stickyDrag: true
}, true);


d3.selectAll('.node').on('mouseover', function(d) {
    highlight_nodes(d.G.neighbors(d.node).concat(d.node), true);
    
});

d3.selectAll('.node').on('mouseout', function(d) {
    highlight_nodes(d.G.neighbors(d.node).concat(d.node), false);
});



// Draggable div - adapted from here: https://www.w3schools.com/howto/howto_js_draggable.asp
//Make the DIV element draggagle:

// Add all the nodes (worksheets) to draggable div
for(let i = 0; i < node_groups.length; i++){
    for (let j = 0; j < node_groups[i].length; j++){
        $("#draggablediv").append(`<p class = "sheetname">${node_groups[i][j]}<p>`);
        console.log(node_groups[i][j]);
    }
        
}

dragElement(document.getElementById("draggablediv"));


// Once sidebar created, increase height of main div to length of sidebar if sidebar is longer than div
console.log($("#canvas").height());
console.log($("#draggablediv").height());
$("#canvas").css("height", $("#draggablediv").height());
console.log($("#canvas").height());
// Event handler for mouseenter and mouseout in sheet name list (to highlight nodes):

let sheet_names = $(".sheetname");
var prev_color;
for (let i = 0; i < sheet_names.length; i++){
    
    sheet_names[i].addEventListener("mouseenter", function( event ) {   

        let element_name = event.target.innerHTML;
        element_name = element_name.replace(/\s/g, '')
        element_name = `#node-${element_name}`

        prev_color = d3.select(element_name).style('fill');
        console.log(prev_color);

        d3.select(element_name).style('fill', '#FF0000');
      }, false)
      sheet_names[i].addEventListener("mouseout", function( event ) {   

        let element_name = event.target.innerHTML;
        element_name = element_name.replace(/\s/g, '')
        element_name = `#node-${element_name}`
        

        d3.select(element_name).style('fill', prev_color);

      }, false);
    
}



// Dragging sidebar code
function dragElement(elmnt) {
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;

  if (document.getElementById(elmnt.id + "header")) {
    /* if present, the header is where you move the DIV from:*/
    document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
  } else {
    /* otherwise, move the DIV from anywhere inside the DIV:*/
    elmnt.onmousedown = dragMouseDown;
  }

  function dragMouseDown(e) {
    e = e || window.event;
    e.preventDefault();
    // get the mouse cursor position at startup:
    pos3 = e.clientX;
    pos4 = e.clientY;
    document.onmouseup = closeDragElement;
    // call a function whenever the cursor moves:
    document.onmousemove = elementDrag;
  }

  function elementDrag(e) {
    e = e || window.event;
    e.preventDefault();
    // calculate the new cursor position:
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    // set the element's new position:
    elmnt.style.top = (elmnt.offsetTop - pos2) + "px";
    elmnt.style.left = (elmnt.offsetLeft - pos1) + "px";
  }

  function closeDragElement() {
    /* stop moving when mouse button is released:*/
    document.onmouseup = null;
    document.onmousemove = null;
  }
}