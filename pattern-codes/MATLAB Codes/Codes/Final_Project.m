function varargout = Final_Project(varargin)
%FINAL_PROJECT M-file for Final_Project.fig
%      FINAL_PROJECT, by itself, creates a new FINAL_PROJECT or raises the existing
%      singleton*.
%
%      H = FINAL_PROJECT returns the handle to a new FINAL_PROJECT or the handle to
%      the existing singleton*.
%
%      FINAL_PROJECT('Property','Value',...) creates a new FINAL_PROJECT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Final_Project_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      FINAL_PROJECT('CALLBACK') and FINAL_PROJECT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in FINAL_PROJECT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Final_Project

% Last Modified by GUIDE v2.5 21-Jan-2014 23:56:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Final_Project_OpeningFcn, ...
    'gui_OutputFcn',  @Final_Project_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
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


% --- Executes just before Final_Project is made visible.
function Final_Project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for Final_Project
handles.output = hObject;
% D_T=datestr(clock);
D_T='version 1.0, copyright © 2014-Jan.';
set(handles.text3,'String',D_T);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Final_Project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Final_Project_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% D_T=datestr(clock);
D_T='version 1.0, copyright © 2014-Jan.';
set(handles.text3,'String',D_T);
popup_sel_index = get(handles.popupmenu1, 'Value');
% load No_features No_features
switch popup_sel_index
    case 1
        %         set(handles.radiobutton4,'Visible','on');
        set(handles.uipanel1,'Title','Number of Features');
        set(handles.n9,'String','9');
        set(handles.radiobutton4,'String','50');
    case 2
        %         set(handles.radiobutton4,'Visible','on');
        set(handles.uipanel1,'Title','Number of Features');
        set(handles.n9,'String','9');
        set(handles.radiobutton4,'String','50');
    case 3
        %         set(handles.radiobutton4,'Visible','on');
        set(handles.uipanel1,'Title','Number of Features');
        set(handles.n9,'String','9');
        set(handles.radiobutton4,'String','50');
    case 4
        %         No_features=9;
        %         save No_features No_features
        %         set(handles.n9,'Value',1);
        %         set(handles.radiobutton4,'Value',0);
        %         set(handles.radiobutton4,'Visible','off');
        set(handles.uipanel1,'Title','Type');
        set(handles.n9,'String','knn');
        set(handles.radiobutton4,'String','naive');
        set(handles.n9,'Position',[0.0632911 0.6 0.929114 0.2]);
        set(handles.radiobutton4,'Position',[0.0632911 0.215385 0.748101 0.2]);
    case 5
        %         set(handles.radiobutton4,'Visible','on');
        set(handles.uipanel1,'Title','Number of Features');
        set(handles.n9,'String','9');
        set(handles.radiobutton4,'String','50');
end
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% axes(handles.axes1);
% cla;
% D_T=datestr(clock);
D_T='version 1.0, copyright © 2014-Jan.';
set(handles.text3,'String',D_T);
popup_sel_index = get(handles.popupmenu1, 'Value');
load No_features No_features
switch popup_sel_index
    case 1
        SVM(No_features);
    case 2
        MLP_Method(No_features);
    case 3
        LS_SVM(No_features);
    case 4
        %         No_features=9;
        %         save No_features No_features
        AdaBoost;
    case 5
        NLCS(No_features);
end

% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
% D_T=datestr(clock);
D_T='version 1.0, copyright © 2014-Jan.';
set(handles.text3,'String',D_T);
if (strcmp(get(hObject, 'String'),'9')==1 || strcmp(get(hObject, 'String'),'knn')==1)
    No_features=9;
    save No_features No_features
else
    No_features = 50;
    save No_features No_features
end

% guidata(handles.n9, handles);


% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
No_features=9;
save No_features No_features
