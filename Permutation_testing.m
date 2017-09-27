function permutation_p_value = Permutation_testing(data)

%example of permutation testing. Assumes data is a graph variable such as clustering, with values across a range
%of thresholds
%Condition labels are randomly permuted to derive a null distribution. Half of the acceptance data and
%half of the evaluation data is assigned to pseudo condition 1, and half of the acceptance data and half of the evaluation
%data is assigned to pseudo condition 2; in each iteration the specific data are selected randomly beyond this constraint. This ensures that each participant contributes to pseudo condition 1 and condition 2, and reflects the null hypothesis assumption that the data of each condition is coming from the same population.

%Input: Data should be a 3d matrix, with rows = participants, columns = clustering values at each threshold, and 3rd
%dimension is evaluation vs acceptance condition
                       

Eval=data(:,:,1);
Accept=data(:,:,2);

Mean_diff=mean(Eval,1)-mean(Accept,1); %actual difference in means between conditions across thresholds
Area_bw_curves=abs(sum(Mean_diff)); %compute area between curves

Data=vertcat(Eval,Accept);

%Create null distribution based on randomized condition labels
Condition_Assign(1:12)=1;Condition_Assign(13:23)=2;
    
for i=1:10000
    rand_Condition_Assign=[];
    rand_Condition_Assign=Condition_Assign(randperm(length(Condition_Assign)))'; %create randomized vector of condition assignments 
    for k=1:23;if rand_Condition_Assign(k,1)==1; rand_Condition_Assign2(k,1)=2;else rand_Condition_Assign2(k,1)=1;end;end %create a 2nd randomized vector of condition assignments that are paired with the 1st vector
    rand_Condition_Assign=vertcat(rand_Condition_Assign,rand_Condition_Assign2); %put randomized vectors together
    Eval_rand=Data(rand_Condition_Assign==1,:); %Assign data to pseudo condition 1 labels
    Accept_rand=Data(rand_Condition_Assign==2,:); %Assign data to pseudo condition 2 labels
    Mean_diff_rand=mean(Eval_rand,1)-mean(Accept_rand,1); %compute difference in means between pseudo conditions 
    Area_bw_curves_rand(i,1)=abs(sum(Mean_diff_rand)); %Store null vaues for each iteration.      
end

Greater_than_mean=find(Area_bw_curves_rand>=Area_bw_curves); %Find values in null distribution that are equal or greater then real condition diff. Because we used absolute values, this results in a 2-tailed p-value
permutation_p_value=size(Greater_than_mean,1)/10000; %Compute proportion

end

    
