/*

*/

var G = new jsnx.DiGraph();

/*
G.addNodesFrom(group_zero, {group:0});
G.addNodesFrom(group_one, {group:1});
G.addNodesFrom(group_two, {group:2});
G.addNodesFrom(group_three, {group:3});
G.addNodesFrom(group_four, {group:4});
G.addNodesFrom(group_five, {group:5});
G.addEdgesFrom(spreadsheet_edges);
*/
for(let i = 0; i < node_groups.length; i++){
    G.addNodesFrom(node_groups[i], {group:i});
    
}
if(a==b){
    
}
G.addEdgesFrom(spreadsheet_edges);

var color = d3.scale.category20();


// helper method to find and style SVG node elements
function highlight_nodes(nodes, on) {
    nodes.forEach(function(n) {
        d3.select('#node-' + n.replace(/\s/g, '')).style('fill', function(d) {
            return on ? '#FFA1A1' : color(d.data.group);
            
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
        linkDistance: 50
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
