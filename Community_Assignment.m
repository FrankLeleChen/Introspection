function [Ci_individual Q_individual Agreement_Matrix_Final] = Community_Assignment(W)

%determine communty assignments at the individual participant level
%Script runs the louvain algorithm 1000x; creates agreement matrix on output; runs the algorithm a final time; and then
%creates a final agreement matrix that will be used in the next step (Community_Assignment_group script) to derive group level community assignments
%uses the community_louvain script from the brain connectivity toolbox 
%
%Input: W, weighted graph for a given subject
%ouput: 
    %Ci_individual, community index vector specifying community asignment for each node
    %Agreement_Matrix_Final, the final individual level co-classification matrix that will be used in the next stage
    %Q_individual, the modularity value for the individual level partition


%Basic parameters
NumIterations=1000; %number of times to run the algorithm
gamma_participant=2; %gamma is the resolution parameter that infuences the number of communities that will be detected. gamma values were selected to find ~ 15-17 communities at each level, to be consistent with other parcellations (e.g., Yeo et al. 2011)
gamma_participant_agreement=2; 
W(W<0)=0;%Remove negative weights
idx = isnan(W); if any(any(idx)); W(idx)=0; end; %Remove NaN self-connections               

%Iterate community detection algorithm
for iteration=1:NumIterations
    Q0 = -1; Q = 0; % initialize modularity values
    while Q-Q0>1e-5; % while modularity increases
        Q0 = Q;
        [Ci Q]=community_louvain(W,gamma_participant);     
    end %while
    
    Individual_communities(iteration,:)=Ci; %Store community assignment vectors for each iteration
    
    %Create co-classification matrix
    for SourceNode=1:length(Ci)
        for node=1:length(Ci)
            if Ci(1,SourceNode)==Ci(1,node) %Determine if each pair of nodes are in same community and assign a value of 1 or 0
                Agreement_matrix(SourceNode,node)=1;
            else
                Agreement_matrix(SourceNode,node)=0;
            end
        end
    end
    
    Agreement_matrix(1:length(Agreement_matrix)+1:end)=0; %make diagonal 0
    Agreement_Matrices(:,:,iteration)=Agreement_matrix; %Store values for each iteration   
end %iterations

Summed_Agreement_Matrix=sum(Agreement_Matrices,3); %add matrices
Probability_Matrix=Summed_Agreement_Matrix./NumIterations; %determine probability (well actually proportion) of co-classification

%determine community assignments on agreement matrix
Q0 = -1; Q_individual = 0; % initialize modularity values
while Q_individual-Q0>1e-5; % while modularity increases
    Q0 = Q_individual;
    [Ci_individual Q_individual]=community_louvain(Probability_Matrix,gamma_participant_agreement);
end %while


%Create agreement matrix on final individual community assignments 
for SourceNode=1:length(Ci_individual)
    for node=1:length(Ci_individual)
        if Ci_individual(1,SourceNode)==Ci_individual(1,node) %Determine if each pair of nodes are in same community
            Agreement_Matrix_Final(SourceNode,node)=1;
        else
            Agreement_Matrix_Final(SourceNode,node)=0;
        end
    end
end
Agreement_Matrix_Final(1:length(Agreement_Matrix_Final)+1:end)=0; %make diagonal 0

end





