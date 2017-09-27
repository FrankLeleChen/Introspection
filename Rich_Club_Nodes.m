function Rich_Club_Nodes_Set = Rich_Club_Nodes(W, ROI_Names)

%Identify putative rich club nodes
%uses the threshold_proportional and degrees_und scripts from the brain connectivity toolbox

%Input: 
    %W should be a 3 dimensional matrix with weighted graphs for all participants, where the 3rd dimension is participant 
    %ROI_Names; cell array with names (strings) of all nodes
    
%Output: Rich_Club_Nodes_Set; a cell array of names of the rich club nodes
        
for i=1:size(W,3)
    W_current=W(:,:,i); %graph for current participant
    W_current(1:length(W_current)+1:end)=0; W_current(W_current<0)=0; %remove negative weights and self-connections
    W_current_thr=threshold_proportional(W_current,.05); %threshold to retain the strongest 5% of weights
    degree(i,:)=degrees_und(W_current_thr); % compute degree of nodes
end

Mean_degree=mean(degree,1); % comute mean degree across participants for each node

[sortedX,sortingIndices] = sort(Mean_degree,'descend'); % sort nodes based on degree
Node_Index=sortingIndices(1:ceil(size(W,1)*.1)); %retain top 10% of nodes based on degree

%Identify the names of rich club nodes
k=0;
for i=Node_Index
    k=k+1;
    Rich_Club_Nodes_Set{k,:}=ROI_Names{i};
end 

end