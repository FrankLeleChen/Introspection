function [C_mean Eglob degree_mean] = Graph_global_properties(W)

% Computes global graph metrics for a range of thresholds (graph weights pruned based on correlation threshold)
% Function calls several scripts from the brain connectivity toolbox (weight_conversion, clustering_coef_wu, efficiency_wei, and degrees_und).
%
% Input: W (weighted graph for a given participant)
% Output: mean values for clustering and degree, and global efficiency

W(isnan(W))=0; %set self-connections to 0
W(W<0)=0; %remove negative connections
W_nrm=weight_conversion(W, 'normalize'); % normalize connections to [0 1] for computing clustering coefficient. 

k=0;
for threshold =0:.01:.99;
    W(W<threshold)=0; %retain positive connections above threshold
    W_nrm(W_nrm<threshold)=0;
    
    k=k+1;
    
    %Clustering - proportion of triangles around node
    C=clustering_coef_wu(W_nrm); %compute clustering values for each node
    C_mean(k,1)=mean(C); %compute mean clustering across the network
    
    % Global Efficiency - average of the inverse shortest pathways between nodes
    Eglob(k,1)=efficiency_wei(W); 
       
    % Degree - mean number of links connected to nodes.
    degree=degrees_und(W);
    degree_mean(k,1)=mean(degree); %compute mean degree across the network
end

end          
            
