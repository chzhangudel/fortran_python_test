#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os
import numpy as np
import matplotlib.pyplot as plt
import copy as copy
import matplotlib as mpl
import netCDF4 as ncd
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.autograd import Variable
import torch.utils.data as Data
import torchvision
from torch import nn, optim
import matplotlib.cm as cm

cwd=os.getcwd()


# In[2]:


class learnKappa(nn.Module):
    def __init__(self, In_nodes, Hid, Out_nodes):
        """
        In_nodes: input vector (forcings)
        H: hidden nodes
        Out_nodes: outputs, here kappa
        
        nn.Linear is a module from pytorch nn....
        """
        super(learnKappa, self).__init__()
        self.linear1 = nn.Linear(In_nodes, Hid) 
        self.linear2 = nn.Linear(Hid, Hid) 
        #self.linear3 = nn.Linear(Hid, Hid) 
        self.linear4 = nn.Linear(Hid, Out_nodes)
        #self.linear3 = nn.Linear(D_out, D_out)

    def forward(self, x):
            """
            torch.sigmoid: sigmoid activation, many more options...
            """
            x2=self.linear1(x)
            h1 = torch.relu(x2)
            #h1 = torch.sigmoid(x2)
            #h_relu2= torch.relu(self.linear2(h_relu))
            h2 = self.linear2(h1)
            h3 = torch.relu(h2)
            #h3 = torch.sigmoid(h2)
            
            #h4 = self.linear3(h3)
            #h5 = torch.relu(h4)
            
            y_pred = self.linear4(h3)
            #y_pred = torch.relu(h4)
            #y_pred = torch.sigmoid(h4)
            
            return y_pred


# In[3]:


in_nod, hid_nod, o_nod = 4, 64, 16
model = learnKappa(in_nod, hid_nod, o_nod)
model.load_state_dict(torch.load('test.pt'), strict=False)


# In[4]:


model.state_dict().keys()


# In[5]:


mod_dict=model.state_dict()


# In[6]:


mod_dict.keys()


# In[7]:


model


# In[8]:


# this code converts the pytorch model 'test.pt' into 6 text files. uncomment to use it

"""
no_of_paramters=len(mod_dict.keys())
no_of_paramters

## create an array of strings to name the text files:
file_name_str=[]
m=0
for i in range(no_of_paramters):
    #file_name_str[i]='w'+str(i)
    if np.mod(i,2)==1:
        m=(int((i)/2))
        file_name_str.append('b'+str(m))
    else:
        m=(int((i)/2))
        file_name_str.append('w'+str(m))
    
for j in range(no_of_paramters):
    np.savetxt(cwd+'/'+file_name_str[j]+'.txt',list(mod_dict.values())[j].detach().numpy())
"""

def wb_out(j):
  wb_py=list(mod_dict.values())[j].detach().numpy()
  wb_py = np.float64(wb_py)
#  print(wb_py)
#  print(wb_py.dtype)
  return wb_py

# In[9]:


# the array outt should match exactly with fortran output

l=30.0; h=-50.0; t=0.3; hb=-100

#l=(l-l_mean)/l_std; 
#h=(h-h_mean)/h_std; 
#t=(t-t_mean)/t_std; 
#hb=(hb-hb_mean)/hb_std; 

#l=l.astype('float32')
input_array=np.array([l,h,t,hb],'float32')
forc=Variable(torch.tensor(input_array))
outt=model(forc)

#k_mean=np.loadtxt('k_mean.txt')
#k_std=np.loadtxt('k_std.txt')

outt=outt.detach().numpy()
print(outt)

