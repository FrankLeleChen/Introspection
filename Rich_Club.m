function Normalized_Rw = Rich_Club(W)
            
%input: W; weighted graph for a given participant
%output: Normalized_Rw; rich club curve for real graph normalized by rich club curve derived from randomized graphs 
%Calls "rich_club_wu" and "randmio_und" from the brain connectivity toolbox

W(isnan(W))=0; %set self-connections to 0
W(W<0)=0; %remove negative connections

[Rw_Real] = rich_club_wu(W,255); %Compute rich club coefficients
Rw_Real(isnan(Rw_Real))=0;%set Nan to 0

%Compute rich club coefficient on 100 random networks
for i=1:100
    R=randmio_und(W,5); %Create randomized network with preserved degree distribution; each edge rewired 5 times
    [Rw_Random] = rich_club_wu(R,255); %Compute rich club coefficients on random matrix
    Rw_Random(isnan(Rw_Random))=0; %set Nan to 0
    Rw_Random_set(i,:)=Rw_Random;
end

[Mean_Random_Rw]=mean(Rw_Random_set,1); %Find mean rich club coefficient across the random networks at each level of k 
[Normalized_Rw]=Rw_Real./Mean_Random_Rw; %compute normalized rich club coefficient as ratio of real Rw to mean of Rw rand, at each level of k

end          
            