function [Ci_Group_Optimal Q_Group_Optimal] = Community_Assignment_Group(All_Subs_Agreement_Matrix_Final)

%input: All_Subs_Agreement_Matrix_Final should be a 3 dimensonal matrix, where dim 1 and 2 repressent the agreement matrix and the 3rd dimension is subject
%output: Ci_Group_optimal, a final group level vector of community assignments for each node

gamma_group=1.75;
NumIterations=1000;

%create agreement matrix reflecting probability of co-classification across individuals
Summed_All_Subs_Agreement_Matrices=sum(All_Subs_Agreement_Matrix_Final,3); %sum matrices
Probability_Matrix_group=Summed_All_Subs_Agreement_Matrices./23; %agreement matrix reflecting probability of co-classification

%determine final community assignments on group level agreement matrix

for j=1:NumIterations
    Q0 = -1; Q_final = 0; % initialize modularity values
    while Q_final-Q0>1e-5; % while modularity increases
        Q0 = Q_final;
        [Ci_Group Q_Group]=community_louvain(Probability_Matrix_group,gamma_group);
    end
    
    Group_Communities(j,:)=Ci_Group; %Store values for each iteration
    Group_Modularity_values(j,:)=Q_Group;
    
end

%Find partition with highest Q value
[Q_Group_Optimal Optimal_Partition_Index]=max(Group_Modularity_values); %find highest q value
Ci_Group_Optimal=Group_Communities(Optimal_Partition_Index,:); %select optimal group Ci as the partition with the highest q value

end