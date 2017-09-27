function Mean_clustering = Clustering_network(W, Ci)
    
%computes mean clustering across nodes from each network 
%Input:
    %W, weighted graph for a given subject
    %Ci, community index vector specifying network affiliation of each node
    
W(1:length(W)+1:end)=0; %set self-connections to 0
W(W<0)=0; %remove negative connections
W_nrm=weight_conversion(W, 'normalize'); %normalize connections to [0 1]

C=clustering_coef_wu(W_nrm)'; %Compute clustering

for i=1:max(Ci)
    Mean_clustering(1,i)=mean(C(Ci==i)); %Compute mean clustering for each network
end
     
end
            
          