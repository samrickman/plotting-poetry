#!/usr/bin/env python
# coding: utf-8

# In[5]:


import plotly_express as px
import pandas as pd
import plotly.graph_objs as go


# In[6]:


df = pd.read_csv("cleaned_data/deaths_per_bed.csv")


# In[7]:


df = df[df["Area name"] != "Hammersmith and Fulham"] # Remove outlier
labels={
                     "death_rate_per_1k_over_65_gen_pop": "Mortality per 1,000 over 65 (outside care homes)",
                     "deaths_per_1k_beds": "Mortality per 1,000 care home beds",
                     "total_beds_ltla": "Total care home beds"
                 }


# In[8]:


fig = px.scatter(df, x="death_rate_per_1k_over_65_gen_pop", 
                 y="deaths_per_1k_beds", 
                 animation_frame="Week number", 
                 animation_group="Area name",
                 size="total_beds_ltla", 
                 color="south_mid_north", 
                 hover_name="Area name", 
                 range_x=[0,16],
                 range_y=[0,114],
                 size_max=45,
                 labels = labels,
                 color_discrete_sequence=px.colors.qualitative.G10,
                 template = "plotly_white",
                title = "Covid-19 deaths: 65+ adults in England local authority districts"                 
             
                )

#fig.update_layout({
#    'plot_bgcolor': 'rgba(0, 0, 0, 0)',
#})
fig.update_layout({
    "legend_title" : ""
})
config = {
    "displayModeBar" : False
}
fig.update_layout(title_x=0.5,
                 annotations=[
            go.layout.Annotation(
                text='Bubble size<br>represents number<br>of care home beds',
                align='left',
                showarrow=False,
                xref='paper',
                yref='paper',
                x=1.1,
                y=0,
                bordercolor='black',
                borderwidth=1
            )
        ])                  
                                 
                
fig.write_html('south_mid_north.html',
              config = config)

