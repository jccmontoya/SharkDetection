function varargout = shark_gui(varargin)
% SHARK_GUI MATLAB code for shark_gui.fig
%      SHARK_GUI, by itself, creates a new SHARK_GUI or raises the existing
%      singleton*.
%
%      H = SHARK_GUI returns the handle to a new SHARK_GUI or the handle to
%      the existing singleton*.
%
%      SHARK_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHARK_GUI.M with the given input arguments.
%
%      SHARK_GUI('Property','Value',...) creates a new SHARK_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before shark_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to shark_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help shark_gui

% Last Modified by GUIDE v2.5 17-Dec-2017 18:47:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @shark_gui_OpeningFcn, ...
    'gui_OutputFcn',  @shark_gui_OutputFcn, ...
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


% --- Executes just before shark_gui is made visible.
function shark_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to shark_gui (see VARARGIN)

% Choose default command line output for shark_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes shark_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

initializeImage(handles)
data(1,:)={[],[],[],[]};
set(handles.uitable1,'data',data);
set(handles.text2, 'String', '');

%Initialize output data
global sharks_labeled
sharks_labeled = 0;
global save_time
save_time = now;
global label_time 
label_time = save_time;


function initializeImage(handles)
global shark_img
shark_img = 'test.JPG';
img = imread(shark_img);
himg = imshow(img,'Parent',handles.img);
dcm_obj = datacursormode(handles.figure1);
set(dcm_obj,'UpdateFcn',@myDatatipUpdateFcn);
dcm_obj.createDatatip(himg);

% Initialize global variables
setLastPoint([0,0]);
setHeadTailIterator(0); % The first labelled position corresponds to the tail
% 0 = label tail; 1 = label head
setHandle(handles);
setImage(img);
global save_info_path
save_info_path = '';

%% Functions to access global variables
function setImage(i)
global img
img = i;

function r = getImage
r = img;

function setHandle(f)
global handle
handle = f;

function r = getHandle
r = handle;

function setLastPoint(val)
global last_point
last_point = val;

function r = getLastPoint
global last_point
r = last_point;

function setHeadTailIterator(val)
global head_tail_iterator
head_tail_iterator = val;

function r = getHeadTailIterator
global head_tail_iterator
r = head_tail_iterator;

function setHead(val)
global head_position
head_position = val;

function r = getHead
global head_position
r = head_position;

function setTail(val)
global tail_position
tail_position = val;

function r = getTail
global tail_position
r = tail_position;


%% Callbacks and othter functions
function txt = myDatatipUpdateFcn(hobj, event_obj)

handles = guidata( event_obj.Target ) ;  %// retrieve the collection of GUI graphic object handles
pointPosition = event_obj.Position;      %// get the position of the datatip

%// Store the position in the figure "appdata", named "pointPosition"
setappdata(handles.figure1 , 'pointPosition' , pointPosition )

%// now we've saved the position in the appdata, you can also display it
%// on the datatip itself
%     txt = {'Point to Compute: ';...
%           ['X:',num2str(pointPosition(1))]; ...
%           ['Y:',num2str(pointPosition(2))] } ;
%     disp(txt);
txt=''; % Override the display of the clicked point
check_point(handles, pointPosition(1), pointPosition(2));
global label_time
label_time = now;

function check_point(handles, point_x, point_y)
% if the point is at the default (initial) position, skip it
if not(point_x == 1 & point_y == (handles.img.YLim(2) - handles.img.YLim(1)))
    % if the current point is the same as the last one, skip it
    last_point = getLastPoint;
    if ((point_x - last_point(1))^2 + (point_y - last_point(2))^2) > 100 %Threshold to prevent dragging
        disp([point_x, point_y]);
        setLastPoint([point_x,point_y]);
        disp(getHeadTailIterator);
        if getHeadTailIterator == 0 % Go for the tail
            setHeadTailIterator(1);
            setTail([point_x, point_y]);
            set(handles.text2, 'String', 'Label head');
            
        else
            set(handles.text2, 'String', 'Label tail');
            setHeadTailIterator(0);
            setHead([point_x, point_y]);
            
            old_point = getTail;
            hold(handles.img,'on')
            try
                % Init x init y end x end y
                plot(handles.img,[point_x, old_point(1)], [point_y, old_point(2)],'Color','k');
            catch
            end
            
            hold(handles.img,'off');
            
            data=get(handles.uitable1, 'data');
            a = data(1,1);
            if isempty(a{1})
                data(1,:)={old_point(1), old_point(2), point_x, point_y};
            else
                data(end+1,:)={old_point(1), old_point(2), point_x, point_y};
            end
            set(handles.uitable1,'data',data);
            add_labelled_data([old_point(1), old_point(2)], [point_x, point_y]);
        end
    end
end


function add_labelled_data(tail,head)
global sharks_labeled
% sharks_labelled = getLabelledData;
% Get center and magnitude of vector
[x,y,u,v] = getVector(tail,head);

if sharks_labeled == 0
    sharks_labeled =  [tail, head, x,y,u,v];
else
    sharks_labeled = [sharks_labeled ; [tail, head, x,y,u,v]];
    
    %setLabelledData(sharks_labelled);
end


% --- Outputs from this function are returned to the command line.
function varargout = shark_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function load_img_Callback(hObject, eventdata, handles)
    % hObject    handle to load_img (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    [FileName,PathName] = uigetfile({'*.png';'*.jpeg';'*.JPEG';'*.JPG';'*.jpg';'*.bmp'},'Select the image to label');
    disp(FileName);
    disp(PathName);
    if(FileName)
        datacursormode off;
        cd(PathName);
        global shark_img
        shark_img = FileName;
        img = imread([PathName, FileName]);
        figure(handles.figure1);
        imshow(img,'Parent',handles.img);
        global save_info_path
        save_info_path = [shark_img, '_labelled.mat'];
        
        % Initialize labeling info
        data(1,:)={[],[],[],[]};
        set(handles.uitable1,'data',data);
        global sharks_labeled
        sharks_labeled = 0;
        global save_time
        save_time = now;
        global label_time 
        label_time = save_time;
        
        % Try to load existing labeling information
        if exist(save_info_path,'file') == 2
            answer = questdlg('There is labelled information associated to this image. Do you want to load it?');
            if strcmp(answer,'Yes')
                labeled_info_to_table(save_info_path,handles);
            end
        end

    end

function plot_labeled_saved_info(sharks_labeled,handles)
    [rows ~] = size(sharks_labeled);
    for i = [1:rows]
        try
            % Init x init y end x end y
            plot(handles.img,[sharks_labeled(i,3), sharks_labeled(i,1)], [sharks_labeled(i,4), sharks_labeled(i,2)],'Color','k');
        catch
        end

    end

function labeled_info_to_table(save_info_path,handles)
    try
        load(save_info_path);
        [rows ~] = size(sharks_labeled);
        hold(handles.img,'on')
        
        data(1,:) = {sharks_labeled(1,1),sharks_labeled(1,2),sharks_labeled(1,3),sharks_labeled(1,4)};
        for i = [2:rows]
            data(end+1,:) = {sharks_labeled(i,1),sharks_labeled(i,2),sharks_labeled(i,3),sharks_labeled(i,4)}; 
        end
        set(handles.uitable1,'data',data);
        plot_labeled_saved_info(sharks_labeled,handles);
    catch
        sharks_labeled = 0;
        data(1,:)={[],[],[],[]};
        set(handles.uitable1,'data',data);
        warningMessage = sprintf('There was a problem when loading information from previous labeling.');
        uiwait(msgbox(warningMessage,'Warning','warn'));
    end
    



% --------------------------------------------------------------------
function save_labeled_info_Callback(hObject, eventdata, handles)
% hObject    handle to save_labeled_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_labeled_information();

% --------------------------------------------------------------------
function save_labeled_data_tooltip_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to save_labeled_data_tooltip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save_labeled_information();

function save_labeled_information()
global sharks_labeled
global shark_img
global save_info_path
save_info_path = [shark_img, '_labelled.mat'];
answer = 'Yes';
if exist(save_info_path,'file') == 2
    answer = questdlg(['The file (' , save_info_path, ') you are trying to save already exists in the current folder. Do you want to overwrite it?']);
end
if strcmp(answer,'Yes')
    save(save_info_path,'sharks_labeled','shark_img');
    global save_time
    save_time = now;
end



% --- Executes during object creation, after setting all properties.
function img_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate img


% --------------------------------------------------------------------
function select_OffCallback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setHeadTailIterator(0); % Reset labelling (next point belongs to tail)
set(handles.text2, 'String', 'Labelling off');


% --------------------------------------------------------------------
function select_OnCallback(hObject, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setHeadTailIterator(0); % Reset labelling (next point belongs to tail)
set(handles.text2, 'String', 'Label tail');


% --------------------------------------------------------------------
function zoom_in_OnCallback(hObject, eventdata, handles)
% hObject    handle to zoom_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2, 'String', 'Zoom in');


% --------------------------------------------------------------------
function zoom_out_OnCallback(hObject, eventdata, handles)
% hObject    handle to zoom_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2, 'String', 'Zoom out');


% --------------------------------------------------------------------
function pan_OnCallback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2, 'String', 'Free move');


% --------------------------------------------------------------------
function zoom_in_OffCallback(hObject, eventdata, handles)
% hObject    handle to zoom_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2, 'String', '');


% --------------------------------------------------------------------
function zoom_out_OffCallback(hObject, eventdata, handles)
% hObject    handle to zoom_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2, 'String', '');


% --------------------------------------------------------------------
function pan_OffCallback(hObject, eventdata, handles)
% hObject    handle to pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'String','');


% --------------------------------------------------------------------


% --------------------------------------------------------------------
function analyze_Callback(hObject, eventdata, handles)
% hObject    handle to analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global save_info_path
global save_time
global label_time 
if label_time > save_time
    warningMessage = sprintf('Labelling information not saved yet.\nPlease, save the data before trying the analysis feature.');
    uiwait(msgbox(warningMessage,'Warning','warn'));
else
    shark_analysis_4_gui(save_info_path)
end


% --------------------------------------------------------------------
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacursormode off;
initializeImage(handles);
data(1,:)={[],[],[],[]};
set(handles.uitable1,'data',data);
set(handles.text2, 'String', '');

%Initialize output data
global sharks_labeled
sharks_labeled = 0;
global save_time
save_time = now;
global label_time 
label_time = save_time;
