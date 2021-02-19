#!/usr/bin/env python
# coding: utf-8

# In[10]:


import plotly_express as px
import plotly.graph_objs as go
import pandas as pd


# In[11]:


df = pd.read_csv("cleaned_data/deaths_per_bed.csv")


# In[13]:


df = df.loc[df["Week number"]==df["Week number"].max()]


# In[14]:


labels={
                     "death_rate_per_1k_over_65_gen_pop": "Mortality per 1,000 over 65 (outside care homes)",
                     "deaths_per_1k_beds": "Mortality per 1,000 care home beds",
                     "total_beds_ltla": "Total care home beds"
                 }


# In[32]:


fig = px.scatter(df, x="death_rate_per_1k_over_65_gen_pop", 
                 y="deaths_per_1k_beds", 
                 animation_group="Area name",
                 size="total_beds_ltla", 
                 color="Deprivation", 
                 hover_name="Area name", 
                 size_max=45,
                 labels = labels,
                 template = "plotly_white",
                 log_x = False, 
                 title = "Covid-19 deaths: 65+ adults in England local authority districts"                 
                )

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
                
fig.write_html('imd_tertile_snapshot.html',
              config = config)

