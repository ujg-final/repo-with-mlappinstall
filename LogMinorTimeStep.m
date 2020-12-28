function LogMinorTimeStep(block)
% Level-2 M file S-Function to log minor time step data of a signal.
%   Copyright 2011 The MathWorks, Inc.

setup(block);
  
%endfunction

function setup(block)

   
  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumDialogPrms  = 4;
  

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;

  %% Set block sample time to inherited
  block.SampleTimes = [-1 0];
  
  %% Register methods
  block.RegBlockMethod('start',                   @start);
  block.RegBlockMethod('Outputs',                 @Output);  
  block.RegBlockMethod('Terminate',               @Terminate);  
%endfunction

function start(block)
    enab = block.DialogPrm(4).Data;
    if (enab)
        assignin('base',block.DialogPrm(1).Data,[]);
        assignin('base',block.DialogPrm(2).Data,[]);
    end
%endfunction

function Output(block)
    enab = block.DialogPrm(4).Data;
    if (enab)
        minordata = evalin('base',block.DialogPrm(1).Data);
        minordata = [minordata; block.CurrentTime block.InputPort(1).Data(:).']; % Log Everything
        assignin('base',block.DialogPrm(1).Data,minordata);

        if( block.IsMajorTimeStep )
            majordata = evalin('base',block.DialogPrm(2).Data);
            majordata = [majordata; block.CurrentTime block.InputPort(1).Data(:).']; % Log Everything
            assignin('base',block.DialogPrm(2).Data,majordata);
        end
    end
%endfunction

function Terminate(block)
    enab = block.DialogPrm(4).Data;
    if (enab)         
          minordata = evalin('base',block.DialogPrm(1).Data);
          majordata = evalin('base',block.DialogPrm(2).Data);
          n = block.DialogPrm(3).Data;
          
          figure(n);
          %figure;
          plot(minordata(:,1),minordata(:,2:end),'-x')
          hold on
          plot(majordata(:,1),majordata(:,2:end),'or')
          hold off
          N = size(majordata,2)-1;
           for i = 1:N
               legtxt{i} = sprintf(['input ',num2str(i),' - Minor']);
           end
           for i = N+1:2*N
               legtxt{i} = sprintf(['input ',num2str(i-N),' - Major']);
           end
           legend(legtxt{:})
    end
%endfunction

