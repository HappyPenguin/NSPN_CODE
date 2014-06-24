%13 May 2014 - Petra Vertes

%arguments of the function:
%Co: the correlation matrix that you want to study
%ext: a string used to name the output file which stores the results
%network measures. This will set the density of datapoints on the curves in
%the final result

%example use:
%NetworkMeasures(A,'myresults');


function NetworkMeasures(Co, ext)

% First make a list of all the subjects in the SUB_DATA directory
cd ('/work/imagingG/NSPN/workspaces/kw401/UCHANGE/INTERIM_ANALYSIS/SUB_DATA')
subs = dir('*')

% Make sure you have the appropriate toolboxes in your path
% Note that if you aren't Kirstie you may have to set these up differently!
addpath(genpath('/home/kw401/Downloads/'))
addpath(genpath('/home/kw401/MATLAB_TOOLBOXES/'))

%Declare the variables to store all measures that will be used
s.cost=[]; s.k=[]; s.a=[]; s.arand=[]; s.M=[]; s.Mrand=[];
s.C=[]; s.Crand=[]; s.L=[]; s.Lrand=[]; s.Sigma=[]; 
s.E=[]; s.Erand=[]; s.CE=[]; s.CErand=[];
s.Diam=[]; s.Diamrand=[]; s.Bass=[]; s.Bassrand=[];
s.name=[];
A=[]; R=[];



% Loop through subjects
for x = 3:length(subs)
    
    s.name=subs(x).name;
    dirname = fullfile(subs(x).name, 'DTI/MRI0/CONNECTIVITY')
    
    if exist(fullfile(dirname,'Msym.txt'), 'file') == 2
        cd (dirname)
    
        Co = load('Msym.txt');

        %Take absolute value of Correlations and set diagonal to ones:
        n=size(Co,1);
        Co=abs(Co);      %%%%%%%%%%%%%%%%%%%%%%%%% TAKING ABS VALUE 
        Co(1:n+1:n*n)=1; %%%%%%%%%%%%%%%%%%%%%%%%% ONES ON DIAGONAL 

        enum=length(find(Co));

        A=Co;
        A(find(Co))=1;

        %Add MST to adjacency matrix to ensure connectedness
        %Create MST (the minimum spanning tree of the network  
        %MST=kruskal_mst(sparse(sqrt(2*(1-Co))));
        % A=full(MST);
        % [i,j]=find(MST);
        % for m=1:length(i)
        %     A(i(m),j(m))= 1; %Co(i(m),j(m));  %(NOT) WEIGHTED VERSION
        %     A(j(m),i(m))= 1; %Co(i(m),j(m));  %(NOT) WEIGHTED VERISON
        % end


        g=1;%we're doing it at a single cost (given by DTI)
        R = randmio_und_connected(A, 5); %make randomized version of the net
        s.cost(g)=enum/(n*(n-1));

        gmeasure; %%THIS FUNCTION CALCULATES THE MEASURES WE WANT

        cd ../../../..
    end
end


%Transfer the structure containing the measures into a correctly named
%variable for saving.
eval(['Meas_' ext '= s;']);

%Save the structure in a .mat file
save(['Meas_' ext '.mat'], ['Meas_' ext]);

%example of plot you might want
boxplot(s.C)
