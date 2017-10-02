function permutation_p_value = Permutation_testing(data)

%example of permutation testing. Data is a graph variable such as clustering, with a single value or a range of values
%across different thresholds
%Condition labels are randomly permuted for each participant to derive a null distribution of mean (pseudo)condition differences. 

%Input: Data should be a 3d matrix, with rows = participants, columns = graph variable values at each threshold, and 3rd
%dimension is evaluation vs acceptance condition
                       
nperm=10000; %number of permutations
Eval=data(:,:,1);
Accept=data(:,:,2);

Area_bw_curve=sum(Accept-Eval,2); %For each participant, create difference score between accept and eval data, and sum across columns (thresholds) 
Mean_diff_abs=abs(nanmean(Area_bw_curve)); %absolute value of actual difference in means between conditions 


%Create null distribution based on randomized condition labels
Data=vertcat(Eval,Accept);
Condition_Assign(1:23,1)=1;Condition_Assign(1:23,2)=2; %condition assignments
    
for i=1:nperm
    
    for j=1:size(data,1)
        current_labels=Condition_Assign(j,:); %select labels for a given participant
        rand_labels=randperm(size(current_labels,2)); %randomly re-assign condition labels
        Pseudo_conditions(j,:)=rand_labels; %store random reassignment for each participant
    end
    
    Pseudo_conditions_stacked=vertcat(Pseudo_conditions(:,1),Pseudo_conditions(:,2));
    Eval_rand=Data(Pseudo_conditions_stacked==1,:); %Assign data to pseudo condition 1 labels
    Accept_rand=Data(Pseudo_conditions_stacked==2,:); %Assign data to pseudo condition 2 labels
    Area_bw_curve_rand=sum(Accept_rand-Eval_rand,2); %compute difference in means between pseudo conditions 
    Null_distribution(i,1)=abs(nanmean(Area_bw_curve_rand)); %Store null vaues for each iteration.      
end

Greater_than_mean=find(Null_distribution>=Mean_diff_abs); %Find values in null distribution that are equal or greater then real condition diff. Because we used absolute values, this results in a 2-tailed p-value
permutation_p_value=size(Greater_than_mean,1)/nperm; %Compute proportion

end

    
