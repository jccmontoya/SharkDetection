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

% Last Modified by GUIDE v2.5 07-Aug-2017 19:06:19

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


function initializeImage(handles)
img = imread('test.JPG');
himg = imshow(img,'Parent',handles.img);
dcm_obj = datacursormode(handles.figure1);
set(dcm_obj,'UpdateFcn',@myDatatipUpdateFcn);
dcm_obj.createDatatip(himg);

% Initialize global variables
setLastPoint([0,0]);
setHeadTailIterator(0); % The first labelled position corresponds to the tail
                        % 0 = label tail; 1 = label head 
setHandle(handles);

                        
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
    
function check_point(handles, point_x, point_y)
    % if the point is at the default (initial) position, skip it
    if not(point_x == 1 & point_y == (handles.img.YLim(2) - handles.img.YLim(1)))
        % if the current point is the same as the last one, skip it
        last_point = getLastPoint;
        if ((point_x - last_point(1))^2 + (point_y - last_point(2))^2) > 100 %Threshold to prevent drag
            disp([point_x, point_y]);
            setLastPoint([point_x,point_y]);
            if getHeadTailIterator == 0 % Time to label the tail
                setHeadTailIterator(1);
                setTail([point_x, point_x]);
                set(handles.text2, 'String', 'Label head');

            else
                set(handles.text2, 'String', 'Label tail');
                setHeadTailIterator(0);
                setHead([point_x, point_y]);
                %set(0,'CurrentFigure',handles.figure1);
             %   set(handles.figure1,'CurrentAxes',handles.axes1);
                %cf = get(0,'CurrentFigure');
               % ca = get(gcf,'CurrentAxes');
               %hold on;
               figure(handles.figure1);
               %hold on;
               % hold off;
               old_point = getTail;
               hold(handles.img,'on');
               scatter(handles.img,100,200);%,'-ko','MarkerSize',12);
               %quiver(100,100,200,200);
               data=get(handles.uitable1, 'data'); 
               a = data(1,1);
               if isempty(a{1})
                    data(1,:)={old_point(1), old_point(2), point_x, point_y};
               else
                    data(end+1,:)={old_point(1), old_point(2), point_x, point_y};
               end
               set(handles.uitable1,'data',data);
            end
        end
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
[FileName,PathName] = uigetfile({'*.jpg';'*.png';'*.bmp'},'Select the image to label');
disp(FileName);
disp(PathName);
if(FileName)
    img = imread([PathName, FileName]);
    figure(handles.figure1);
    imshow(img,'Parent',handles.img);
end



% --------------------------------------------------------------------
function save_labelled_info_Callback(hObject, eventdata, handles)
% hObject    handle to save_labelled_info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function img_CreateFcn(hObject, eventdata, handles)
% hObject    handle to img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate img


% --------------------------------------------------------------------
function uitoggletool5_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setHeadTailIterator(0); % Reset labelling (next point belongs to tail)
set(handles.text2, 'String', 'Labelling off');


% --------------------------------------------------------------------
function uitoggletool5_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool5 (see GCBO)
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
set(handles.text2, 'String', '');
