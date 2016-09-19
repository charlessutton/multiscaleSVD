%
% This file runs all examples of the presentation / report and creates corresponding figures 
% Execute 'clear all' before running the script, otherwise it will re-run with any existing options without prompting the user.

% list of examples
examples   = { '9-d sphere without noise', ...
    '9-d sphere with little noise', ...
    '1-D gaussian pulse', ...
    'k concatenated 1D gaussian pulse', ...
    };

fprintf('\n\n Select example to run:\n');
for k = 1:length(examples),
    fprintf('\n [%d] %s',k,examples{k});
end;
fprintf('\n\n  ');

while true,
    if (~exist('pExampleIdx') || isempty(example_id) || example_id==0),
        try
            example_id = input('');
            example_id = str2num(example_id);
        catch
        end;
    end;
    if (example_id>=1) && (example_id<=length(examples)),
        break;
    else
        fprintf('\n %d is not a valid Example. Please select a valid Example above.',example_id);
        example_id=0;
    end;
end;

switch example_id
    case 1
        data_type = 'sphere'; 
        
        