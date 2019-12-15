function varargout = EquationSolver(varargin)
% EQUATIONSOLVER MATLAB code for EquationSolver.fig
%      EQUATIONSOLVER, by itself, creates a new EQUATIONSOLVER or raises the existing
%      singleton*.
%
%      H = EQUATIONSOLVER returns the handle to a new EQUATIONSOLVER or the handle to
%      the existing singleton*.
%
%      EQUATIONSOLVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EQUATIONSOLVER.M with the given input arguments.
%
%      EQUATIONSOLVER('Property','Value',...) creates a new EQUATIONSOLVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EquationSolver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EquationSolver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EquationSolver

% Last Modified by GUIDE v2.5 15-Dec-2019 18:17:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EquationSolver_OpeningFcn, ...
                   'gui_OutputFcn',  @EquationSolver_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before EquationSolver is made visible.
function EquationSolver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EquationSolver (see VARARGIN)

% Choose default command line output for EquationSolver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EquationSolver wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EquationSolver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function inputText_Callback(hObject, eventdata, handles)
% hObject    handle to inputText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputText as text
%        str2double(get(hObject,'String')) returns contents of inputText as a double

% --- Executes during object creation, after setting all properties.

function inputText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userInput = get(handles.inputText,'String');
set(handles.pushbutton2,'enable','off');
set(handles.calculating,'Visible','On');
drawnow();
try
    inputSize = size(userInput);
    if inputSize(2) == 0
        error("No Values")
    end
    [eqn,LHS,RHS,vars] = inputProcessor(userInput)
    % check for incomplete equations
    LHSSize = size(LHS);
    varsSize = size(vars);
    if varsSize(1,2) > LHSSize(1,1)
        error("Incomplete Equations");
    end
    
    eqnText = "";
    [dummy,eqnCellSize] = size(eqn);
    eqn = char(eqn);
    if eqnCellSize > 1 % check if eqn is begin with 'matrix'
        eqn([1:9, end-2:end]) = [];
    end
    eqn = split(eqn,', ');
    eqnSize = size(eqn);
    for i = 1:eqnSize(1,1)
        eqnText = eqnText + convertCharsToStrings(eqn(i,:));
        if contains(eqn(i,:),"==") == 0
            eqnText = eqnText + " == 0"
        end
        eqnText = eqnText + newline;
    end
    set(handles.listbox3,'String',eqnText);
    set(handles.text22,'Visible','On');
    set(handles.listbox3,'Visible','On');
    tic;
    [tA,tb] = GaussPivot(LHS,RHS);
    [tA,tb] = BackwardSub(tA,tb);
    timeSparks = toc;
    ansText = eqnmat2str(tb,vars);
    set(handles.listbox4,'String',ansText);
    set(handles.timeSpark,'String',"using " + num2str(timeSparks) + " second(s)");
    
    tic
    tb = GaussPivotLoops(LHS,RHS);
    timeLoops = toc;
    
    ansText = eqnmat2str(tb,vars);
    set(handles.listbox5,'String',ansText);
    set(handles.timeLoop,'String',"using " + num2str(timeLoops) + " second(s)");
    
    
    
    set(handles.text12,'Visible','On');
    set(handles.listbox3,'Visible','On');
    set(handles.text12,'Visible','On');
    set(handles.listbox4,'Visible','On');
    set(handles.text24,'Visible','On');
    set(handles.listbox5,'Visible','On');
    set(handles.text27,'Visible','On');
    set(handles.timeSpark,'Visible','On');
    set(handles.timeLoop,'Visible','On');
    
    set(handles.pushbutton2,'enable','on');
    set(handles.calculating,'Visible','Off');
catch err
    disp(err.message)
    set(handles.inputText,'ForegroundColor',[0.99,0.20,0.43]);
    set(handles.inputText,'FontWeight','bold');
    set(handles.text22,'Visible','Off');
    set(handles.listbox3,'Visible','Off');
    set(handles.text12,'Visible','Off');
    set(handles.listbox4,'Visible','Off');
    set(handles.text24,'Visible','Off');
    set(handles.listbox5,'Visible','Off');
    set(handles.text27,'Visible','Off');
    set(handles.timeSpark,'Visible','Off');
    set(handles.timeLoop,'Visible','Off');
    
    set(handles.pushbutton2,'enable','on');
    set(handles.calculating,'Visible','Off');
    
end


% --- Executes on key press with focus on inputText and none of its controls.
function inputText_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to inputText (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

set(handles.inputText,'ForegroundColor','black');
set(handles.inputText,'FontWeight','normal');

% --- Executes on button press in importpb.
function importpb_Callback(hObject, eventdata, handles)
% hObject    handle to importpb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.inputText,'ForegroundColor','black');
set(handles.inputText,'FontWeight','normal');
[filename, pathname] = uigetfile({'*.txt'},'File Selector');
if ~ischar(filename)
    return;  % User aborted the file selection
end
file = fullfile(pathname, filename);
[fid, msg] = fopen(file, 'r');
Data = fscanf(fid, '%s', [1, inf]);
set(handles.inputText,'String',Data);
fclose(fid);


% --- Executes on button press in randompb.
function randompb_Callback(hObject, eventdata, handles)
% hObject    handle to randompb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.edit4,'String');
minval = get(handles.minvaluebox,'String');
maxval = get(handles.maxvaluebox,'String');
if isempty(str2num(str))
    set(src,'string','0');
end
set(handles.inputText,'String',randomEqns(str2num(str),str2num(minval),str2num(maxval)));



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox4.
function listbox4_Callback(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox4


% --- Executes during object creation, after setting all properties.
function listbox4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox5.
function listbox5_Callback(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox5


% --- Executes during object creation, after setting all properties.
function listbox5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minvaluebox_Callback(hObject, eventdata, handles)
% hObject    handle to minvaluebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minvaluebox as text
%        str2double(get(hObject,'String')) returns contents of minvaluebox as a double


% --- Executes during object creation, after setting all properties.
function minvaluebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minvaluebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxvaluebox_Callback(hObject, eventdata, handles)
% hObject    handle to maxvaluebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxvaluebox as text
%        str2double(get(hObject,'String')) returns contents of maxvaluebox as a double


% --- Executes during object creation, after setting all properties.
function maxvaluebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxvaluebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
