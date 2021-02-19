// based on https://chart-studio.plotly.com/~cesc/14#code

trace1 = {
  uid: 'df6b1c', 
  line: {
    dash: 'solid', 
    color: 'rgb(226, 181, 91)', 
    shape: 'spline', 
    width: 2, 
    smoothing: 1.3
  }, 
  mode: 'lines', 
  name: 'Line of Imports', 
  type: 'scatter', 
  x: ['1700-1-1', '1705-1-1', '1710-1-1', '1715-1-1', '1720-1-1', '1725-1-1', '1730-1-1', '1735-1-1', '1740-1-1', '1745-1-1', '1750-1-1', '1755-1-1'], 
  y: ['71264.82213438736', '75195.85979914182', '82679.08316800214', '87398.58404720525', '96860.14262058925', '101974.90041678841', '97601.44158553901', '93230.03337383305', '93203.37531976847', '92388.76670614109', '89993.13042452949', '80881.71513818612'], 
  marker: {
    line: {
      color: '#000', 
      width: 0
    }, 
    size: 6, 
    cauto: true, 
    color: 'rgb(0, 67, 88)', 
    symbol: 'hexagon-open', 
    opacity: 1, 
    colorscale: [['0', 'rgb(8, 29, 88)'], ['0.125', 'rgb(37, 52, 148)'], ['0.25', 'rgb(34, 94, 168)'], ['0.375', 'rgb(29, 145, 192)'], ['0.5', 'rgb(65, 182, 196)'], ['0.625', 'rgb(127, 205, 187)'], ['0.75', 'rgb(199, 233, 180)'], ['0.875', 'rgb(237, 248, 217)'], ['1', 'rgb(255, 255, 217)']], 
    maxdisplayed: 0
  }, 
  error_x: {copy_ystyle: true}, 
  error_y: {
    color: 'rgb(0, 67, 88)', 
    width: 1, 
    thickness: 1
  }, 
  opacity: 1, 
  textfont: {
    size: 12, 
    color: 'rgb(84, 84, 84)', 
    family: 'Verdana, sans-serif'
  }, 
  fillcolor: 'rgba(245, 33, 242, 0.5)', 
  textposition: 'middle center'
};
trace2 = {
  uid: 'cf42f4', 
  fill: 'tonexty', 
  line: {
    dash: 'solid', 
    color: 'rgb(255, 80, 86)', 
    shape: 'spline', 
    width: 2
  }, 
  mode: 'lines', 
  name: 'Line of Exports', 
  type: 'scatter', 
  x: ['1700-1-1', '1705-1-1', '1710-1-1', '1715-1-1', '1720-1-1', '1725-1-1', '1730-1-1', '1735-1-1', '1740-1-1', '1745-1-1', '1750-1-1', '1755-1-1'], 
  y: ['33320.67075765264', '41203.2522825959', '59358.92506523535', '77121.904205308', '76306.27028190892', '73123.70875050625', '64795.11747486709', '60819.478835043', '65534.87847515929', '74207.46117920877', '77740.16599765202', '80881.71513818612'], 
  marker: {
    line: {
      color: '#000', 
      width: 0
    }, 
    size: 6, 
    cauto: true, 
    color: 'rgb(31, 138, 255)', 
    symbol: 'hexagon-open', 
    opacity: 1, 
    colorscale: [['0', 'rgb(8, 29, 88)'], ['0.125', 'rgb(37, 52, 148)'], ['0.25', 'rgb(34, 94, 168)'], ['0.375', 'rgb(29, 145, 192)'], ['0.5', 'rgb(65, 182, 196)'], ['0.625', 'rgb(127, 205, 187)'], ['0.75', 'rgb(199, 233, 180)'], ['0.875', 'rgb(237, 248, 217)'], ['1', 'rgb(255, 255, 217)']]
  }, 
  error_x: {copy_ystyle: true}, 
  error_y: {
    color: 'rgb(31, 138, 112)', 
    width: 1, 
    thickness: 1
  }, 
  opacity: 1, 
  textfont: {
    size: 12, 
    color: 'rgb(84, 84, 84)', 
    family: 'Verdana, sans-serif'
  }, 
  fillcolor: 'rgba(239, 211, 207, 1)', 
  textposition: 'middle center'
};
trace3 = {
  uid: '66bbb4', 
  line: {
    dash: 'solid', 
    color: 'rgb(139, 80, 255)', 
    shape: 'spline', 
    width: 2
  }, 
  mode: 'lines', 
  name: 'Line of Exports', 
  type: 'scatter', 
  x: ['1755-1-1', '1757-1-1', '1760-1-1', '1765-1-1', '1770-1-1', '1775-1-1', '1780-1-1'], 
  y: ['80881.71513818612', '93907.76313293652', '119191.38944853713', '146442.07256117254', '162620.43544906002', '176431.35807405808', '184705.09527691052'], 
  marker: {
    line: {
      color: '#000', 
      width: 0
    }, 
    size: 6, 
    cauto: true, 
    color: 'rgb(190, 219, 57)', 
    symbol: 'hexagon-open', 
    opacity: 1, 
    colorscale: [['0', 'rgb(8, 29, 88)'], ['0.125', 'rgb(37, 52, 148)'], ['0.25', 'rgb(34, 94, 168)'], ['0.375', 'rgb(29, 145, 192)'], ['0.5', 'rgb(65, 182, 196)'], ['0.625', 'rgb(127, 205, 187)'], ['0.75', 'rgb(199, 233, 180)'], ['0.875', 'rgb(237, 248, 217)'], ['1', 'rgb(255, 255, 217)']]
  }, 
  error_x: {copy_ystyle: true}, 
  error_y: {
    color: 'rgb(190, 219, 57)', 
    width: 1, 
    thickness: 1
  }, 
  opacity: 1, 
  textfont: {
    size: 12, 
    color: 'rgb(84, 84, 84)', 
    family: 'Verdana, sans-serif'
  }, 
  fillcolor: 'rgba(108, 56, 109, 1)', 
  textposition: 'middle center'
};
trace4 = {
  uid: '9ec1ca', 
  fill: 'tonexty', 
  line: {
    dash: 'solid', 
    color: 'rgb(211, 211, 211)', 
    shape: 'spline', 
    width: 2
  }, 
  mode: 'lines', 
  name: 'Line of Imports', 
  type: 'scatter', 
  x: ['1755-1-1', '1757-1-1', '1760-1-1', '1765-1-1', '1770-1-1', '1775-1-1', '1780-1-1'], 
  y: ['80881.71513818612', '76911.71570210648', '76898.3866750742', '78459.42080250994', '83569.05204985055', '90657.53115660066', '92214.46404494956'], 
  marker: {
    line: {
      color: '#000', 
      width: 0
    }, 
    size: 6, 
    cauto: true, 
    color: 'rgb(255, 225, 255)', 
    symbol: 'hexagon-open', 
    opacity: 1, 
    colorscale: [['0', 'rgb(8, 29, 88)'], ['0.125', 'rgb(37, 52, 148)'], ['0.25', 'rgb(34, 94, 168)'], ['0.375', 'rgb(29, 145, 192)'], ['0.5', 'rgb(65, 182, 196)'], ['0.625', 'rgb(127, 205, 187)'], ['0.75', 'rgb(199, 233, 180)'], ['0.875', 'rgb(237, 248, 217)'], ['1', 'rgb(255, 255, 217)']]
  }, 
  error_x: {copy_ystyle: true}, 
  error_y: {
    color: 'rgb(255, 225, 26)', 
    width: 1, 
    thickness: 1
  }, 
  opacity: 1, 
  textfont: {
    size: 12, 
    color: 'rgb(84, 84, 84)', 
    family: 'Verdana, sans-serif'
  }, 
  fillcolor: 'rgba(223, 208, 255, 1)', 
  textposition: 'middle center'
};
trace5 = {
  uid: '10b5e9', 
  line: {
    color: 'rgb(253, 116, 255)', 
    shape: 'spline', 
    width: 0.5
  }, 
  mode: 'lines', 
  name: 'Balance', 
  type: 'scatter', 
  x: ['1690-1-1', null, null, null, null, null, '1790-1-1'], 
  y: ['100000', null, null, null, null, null, '100000'], 
  marker: {
    line: {
      color: '#000', 
      width: 0
    }, 
    color: 'rgb(253, 116, 0)', 
    symbol: 'hexagon-open', 
    opacity: 1
  }, 
  error_x: {copy_ystyle: true}, 
  error_y: {
    color: 'rgb(253, 116, 0)', 
    width: 1, 
    thickness: 1
  }, 
  opacity: 1, 
  connectgaps: true
};
data = [trace1, trace2, trace3, trace4, trace5];
layout = {
  font: {
    size: 12, 
    color: '#000', 
    family: 'Arial, sans-serif'
  }, 
  smith: false, 
  title: '<br>Exports and Imports to and from <b>DENMARK</b> & <b>NORWAY</b> from 1700 to 1780', 
  width: 800, 
  xaxis: {
    side: 'bottom', 
    type: 'date', 
    dtick: 'M120', 
    range: [-8835850800000, -5680177200000], 
    tick0: 946713600000, 
    ticks: '', 
    title: '<i>Published as the Act directs, 14th May 1786, by <a href="http://en.wikipedia.org/wiki/William_Playfair">W. Playfair</a></i><br><i>Neele sculpf 352, Strand, London.</i>', 
    anchor: 'y', 
    domain: [0, 1], 
    nticks: 0, 
    showgrid: false, 
    showline: false, 
    tickfont: {
      size: 12, 
      color: '#000', 
      family: 'Arial, sans-serif'
    }, 
    tickmode: 'auto', 
    zeroline: false, 
    autorange: true, 
    tickangle: 'auto', 
    titlefont: {
      size: 12, 
      color: 'rgb(102, 102, 102)', 
      family: 'Arial, sans-serif'
    }, 
    tickformat: '', 
    hoverformat: '', 
    showexponent: 'all', 
    exponentformat: 'e', 
    showticklabels: true
  }, 
  yaxis: {
    side: 'right', 
    type: 'log', 
    dtick: 20000, 
    range: [4.481393449738472, 5.3077991616539], 
    tick0: 0, 
    ticks: '', 
    title: 'Imports vs. Exports (£)', 
    anchor: 'x', 
    domain: [0, 1], 
    nticks: 9, 
    showgrid: true, 
    showline: false, 
    tickfont: {
      size: 12, 
      color: 'rgb(102, 102, 102)', 
      family: 'Arial, sans-serif'
    }, 
    tickmode: 'auto', 
    zeroline: false, 
    autorange: true, 
    gridcolor: '#ddd', 
    gridwidth: 3, 
    tickangle: 'auto', 
    titlefont: {
      size: 14, 
      color: 'rgb(102, 102, 102)', 
      family: 'Arial, sans-serif'
    }, 
    showexponent: 'all', 
    exponentformat: 'B', 
    showticklabels: true
  }, 
  height: 550, 
  margin: {
    b: 80, 
    l: 80, 
    r: 20, 
    t: 50, 
    pad: 0, 
    autoexpand: true
  }, 
  autosize: false, 
  dragmode: 'zoom', 
  hovermode: 'x', 
  titlefont: {
    size: 14, 
    color: 'rgb(102, 102, 102)', 
    family: 'Arial, sans-serif'
  }, 
  separators: '.,', 
  showlegend: true, 
  legend: {
    x: 1.1,
    y: 0.5
  },
  hidesources: false, 
  plot_bgcolor: '#fff', 
  paper_bgcolor: '#fff'
};
Plotly.newPlot('plotly-div', 
  data,
  layout,
  {displayModeBar: false}
);