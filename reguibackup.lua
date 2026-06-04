local a a={cache={},load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}
end return a.cache[b].c end}do function a.a()local b,c,d='8.0',cloneref or
function(b)return b end,{Theme={Syntax={Text=Color3.fromRGB(204,204,204),
Background=Color3.fromRGB(20,20,20),Selection=Color3.fromRGB(255,255,255),
SelectionBack=Color3.fromRGB(102,161,255),Operator=Color3.fromRGB(204,204,204),
Number=Color3.fromRGB(255,198,0),String=Color3.fromRGB(172,240,148),Comment=
Color3.fromRGB(102,102,102),Keyword=Color3.fromRGB(248,109,124),BuiltIn=Color3.
fromRGB(132,214,247),LocalMethod=Color3.fromRGB(253,251,172),LocalProperty=
Color3.fromRGB(97,161,241),Nil=Color3.fromRGB(255,198,0),Bool=Color3.fromRGB(255
,198,0),Function=Color3.fromRGB(248,109,124),Local=Color3.fromRGB(248,109,124),
Self=Color3.fromRGB(248,109,124),FunctionName=Color3.fromRGB(253,251,172),
Bracket=Color3.fromRGB(204,204,204)}}}local e,f=setmetatable({},{__index=
function(e,f)local g=game:GetService(f)return c(g)end}),Instance.new'Frame'local
g,h,i,j=e.Players,e.UserInputService,e.RunService,e.TweenService local k=g.
LocalPlayer local l,m,n=k:GetMouse(),function(l,m)for n,o in next,m do l[n]=o
end return l end,{}n.CheckMouseInGui=function(o)if o==nil then return false end
local p,q=o.AbsolutePosition,o.AbsoluteSize return l.X>=p.X and l.X<p.X+q.X and
l.Y>=p.Y and l.Y<p.Y+q.Y end n.Signal=(function()local o,p={},function(o)local p
=table.find(o.Signal.Connections,o)if p then table.remove(o.Signal.Connections,p
)end end o.Connect=function(q,r)if type(r)~='function'then error
'Attempt to connect a non-function'end local s={Signal=q,Func=r,Disconnect=p}q.
Connections[#q.Connections+1]=s return s end o.Fire=function(q,...)for r,s in
next,q.Connections do xpcall(coroutine.wrap(s.Func),function(t)warn(t..'\n'..
debug.traceback())end,...)end end local q={__index=o,__tostring=function(q)
return'Signal: '..tostring(#q.Connections)..' Connections'end}local r=function()
local r={}r.Connections={}return setmetatable(r,q)end return{new=r}end)()local o
=function(o,p)local q=Instance.new(o)for r,s in next,p do q[r]=s end return q
end n.CreateArrow=function(p,q,r)local s,t=q,o('Frame',{BackgroundTransparency=1
,Name='Arrow',Size=UDim2.new(0,p,0,p)})if r=='up'then for u=1,q do o('Frame',{
BackgroundColor3=Color3.new(0.8627450980392157,0.8627450980392157,
0.8627450980392157),BorderSizePixel=0,Position=UDim2.new(0,math.floor(p/2)-(u-1)
,0,math.floor(p/2)+u-math.floor(s/2)-1),Size=UDim2.new(0,u+(u-1),0,1),Parent=t})
end return t elseif r=='down'then for u=1,q do o('Frame',{BackgroundColor3=
Color3.new(0.8627450980392157,0.8627450980392157,0.8627450980392157),
BorderSizePixel=0,Position=UDim2.new(0,math.floor(p/2)-(u-1),0,math.floor(p/2)-u
+math.floor(s/2)+1),Size=UDim2.new(0,u+(u-1),0,1),Parent=t})end return t elseif
r=='left'then for u=1,q do o('Frame',{BackgroundColor3=Color3.new(
0.8627450980392157,0.8627450980392157,0.8627450980392157),BorderSizePixel=0,
Position=UDim2.new(0,math.floor(p/2)+u-math.floor(s/2)-1,0,math.floor(p/2)-(u-1)
),Size=UDim2.new(0,1,0,u+(u-1)),Parent=t})end return t elseif r=='right'then for
u=1,q do o('Frame',{BackgroundColor3=Color3.new(0.8627450980392157,
0.8627450980392157,0.8627450980392157),BorderSizePixel=0,Position=UDim2.new(0,
math.floor(p/2)-u+math.floor(s/2)+1,0,math.floor(p/2)-(u-1)),Size=UDim2.new(0,1,
0,u+(u-1)),Parent=t})end return t end error''end n.FastWait=(function(p)task.
wait(p)end)n.ScrollBar=(function()local p,q,r,s={},n.CheckMouseInGui,n.
CreateArrow,function(p)local q,r,s,t=p.TotalSpace,p.VisibleSpace,p.GuiElems.
ScrollThumb,p.GuiElems.ScrollThumbFrame if not(p:CanScrollUp()or p:
CanScrollDown())then s.Visible=false else s.Visible=true end if p.Horizontal
then s.Size=UDim2.new(r/q,0,1,0)if s.AbsoluteSize.X<10 then s.Size=UDim2.new(0,
10,1,0)end local u,v=t.AbsoluteSize.X,s.AbsoluteSize.X s.Position=UDim2.new(p:
GetScrollPercent()*(u-v)/u,0,0,0)else s.Size=UDim2.new(1,0,r/q,0)if s.
AbsoluteSize.Y<10 then s.Size=UDim2.new(1,0,0,10)end local u,v=t.AbsoluteSize.Y,
s.AbsoluteSize.Y s.Position=UDim2.new(0,0,p:GetScrollPercent()*(u-v)/u,0)end end
local t=function(t)local u,v,w=(o('Frame',{Style=0,Active=true,AnchorPoint=
Vector2.new(0,0),BackgroundColor3=Color3.new(0.35294118523598,0.35294118523598,
0.35294118523598),BackgroundTransparency=0,BorderColor3=Color3.new(
0.10588236153126,0.16470588743687,0.20784315466881),BorderSizePixel=0,
ClipsDescendants=false,Draggable=false,Position=UDim2.new(1,-10,0,0),Rotation=0,
Selectable=false,Size=UDim2.new(0,10,1,0),SizeConstraint=0,Visible=true,ZIndex=1
,Name='ScrollBar'}))if t.Horizontal then u.Size=UDim2.new(1,0,0,10)v=o(
'ImageButton',{Parent=u,Name='Left',Size=UDim2.new(0,10,0,10),
BackgroundTransparency=1,BorderSizePixel=0,AutoButtonColor=false})r(10,4,'left')
.Parent=v w=o('ImageButton',{Parent=u,Name='Right',Position=UDim2.new(1,-10,0,0)
,Size=UDim2.new(0,10,0,10),BackgroundTransparency=1,BorderSizePixel=0,
AutoButtonColor=false})r(10,4,'right').Parent=w else u.Size=UDim2.new(0,10,1,0)v
=o('ImageButton',{Parent=u,Name='Up',Size=UDim2.new(0,10,0,10),
BackgroundTransparency=1,BorderSizePixel=0,AutoButtonColor=false})r(10,4,'up').
Parent=v w=o('ImageButton',{Parent=u,Name='Down',Position=UDim2.new(0,0,1,-10),
Size=UDim2.new(0,10,0,10),BackgroundTransparency=1,BorderSizePixel=0,
AutoButtonColor=false})r(10,4,'down').Parent=w end local x=o('Frame',{
BackgroundTransparency=1,Parent=u})if t.Horizontal then x.Position=UDim2.new(0,
10,0,0)x.Size=UDim2.new(1,-20,1,0)else x.Position=UDim2.new(0,0,0,10)x.Size=
UDim2.new(1,0,1,-20)end local y,z,A,B,C=o('Frame',{BackgroundColor3=Color3.new(
0.47058823529411764,0.47058823529411764,0.47058823529411764),BorderSizePixel=0,
Parent=x}),o('Frame',{BackgroundTransparency=1,Name='Markers',Size=UDim2.new(1,0
,1,0),Parent=x}),false,false,false v.InputBegan:Connect(function(D)if D.
UserInputType==Enum.UserInputType.MouseMovement and not A and t:CanScrollUp()
then v.BackgroundTransparency=0.8 end if D.UserInputType~=Enum.UserInputType.
MouseButton1 or not t:CanScrollUp()then return end A=true v.
BackgroundTransparency=0.5 if t:CanScrollUp()then t:ScrollUp()t.Scrolled:Fire()
end local E,F=(tick())F=h.InputEnded:Connect(function(G)if G.UserInputType~=Enum
.UserInputType.MouseButton1 then return end F:Disconnect()if q(v)and t:
CanScrollUp()then v.BackgroundTransparency=0.8 else v.BackgroundTransparency=1
end A=false end)while A do if tick()-E>=0.3 and t:CanScrollUp()then t:ScrollUp()
t.Scrolled:Fire()end wait()end end)v.InputEnded:Connect(function(D)if D.
UserInputType==Enum.UserInputType.MouseMovement and not A then v.
BackgroundTransparency=1 end end)w.InputBegan:Connect(function(D)if D.
UserInputType==Enum.UserInputType.MouseMovement and not A and t:CanScrollDown()
then w.BackgroundTransparency=0.8 end if D.UserInputType~=Enum.UserInputType.
MouseButton1 or not t:CanScrollDown()then return end A=true w.
BackgroundTransparency=0.5 if t:CanScrollDown()then t:ScrollDown()t.Scrolled:
Fire()end local E,F=(tick())F=h.InputEnded:Connect(function(G)if G.UserInputType
~=Enum.UserInputType.MouseButton1 then return end F:Disconnect()if q(w)and t:
CanScrollDown()then w.BackgroundTransparency=0.8 else w.BackgroundTransparency=1
end A=false end)while A do if tick()-E>=0.3 and t:CanScrollDown()then t:
ScrollDown()t.Scrolled:Fire()end wait()end end)w.InputEnded:Connect(function(D)
if D.UserInputType==Enum.UserInputType.MouseMovement and not A then w.
BackgroundTransparency=1 end end)y.InputBegan:Connect(function(D)if D.
UserInputType==Enum.UserInputType.MouseMovement and not B then y.
BackgroundTransparency=0.2 y.BackgroundColor3=t.ThumbSelectColor end if D.
UserInputType~=Enum.UserInputType.MouseButton1 then return end local E,F=t.
Horizontal and'X'or'Y'A=false C=false B=true y.BackgroundTransparency=0 local G,
H,I=(l[E]-y.AbsolutePosition[E])H=h.InputEnded:Connect(function(J)if J.
UserInputType~=Enum.UserInputType.MouseButton1 then return end H:Disconnect()if
I then I:Disconnect()end if q(y)then y.BackgroundTransparency=0.2 else y.
BackgroundTransparency=0 y.BackgroundColor3=t.ThumbColor end B=false end)t:
Update()I=h.InputChanged:Connect(function(J)if J.UserInputType==Enum.
UserInputType.MouseMovement and B and H.Connected then local K,L=x.AbsoluteSize[
E]-y.AbsoluteSize[E],l[E]-x.AbsolutePosition[E]-G if L>K then L=K elseif L<0
then L=0 end if F~=L then F=L t:ScrollTo(math.floor(0.5+L/K*(t.TotalSpace-t.
VisibleSpace)))end wait()end end)end)y.InputEnded:Connect(function(D)if D.
UserInputType==Enum.UserInputType.MouseMovement and not B then y.
BackgroundTransparency=0 y.BackgroundColor3=t.ThumbColor end end)x.InputBegan:
Connect(function(D)if D.UserInputType~=Enum.UserInputType.MouseButton1 or q(y)
then return end local E,F=t.Horizontal and'X'or'Y',0 if l[E]>=y.AbsolutePosition
[E]+y.AbsoluteSize[E]then F=1 end local G=function()local G=t.VisibleSpace-1 if
F==0 and l[E]<y.AbsolutePosition[E]then t:ScrollTo(t.Index-G)elseif F==1 and l[E
]>=y.AbsolutePosition[E]+y.AbsoluteSize[E]then t:ScrollTo(t.Index+G)end end B=
false C=true G()local H,I=(tick())I=h.InputEnded:Connect(function(J)if J.
UserInputType~=Enum.UserInputType.MouseButton1 then return end I:Disconnect()C=
false end)while C do if tick()-H>=0.3 and q(x)then G()end wait()end end)u.
MouseWheelForward:Connect(function()t:ScrollTo(t.Index-t.WheelIncrement)end)u.
MouseWheelBackward:Connect(function()t:ScrollTo(t.Index+t.WheelIncrement)end)t.
GuiElems.ScrollThumb=y t.GuiElems.ScrollThumbFrame=x t.GuiElems.Button1=v t.
GuiElems.Button2=w t.GuiElems.MarkerFrame=z return u end p.Update=function(u,v)
local w,x,y,z=u.TotalSpace,u.VisibleSpace,u.GuiElems.Button1,u.GuiElems.Button2
u.Index=math.clamp(u.Index,0,math.max(0,w-x))if u.LastTotalSpace~=u.TotalSpace
then u.LastTotalSpace=u.TotalSpace u:UpdateMarkers()end if u:CanScrollUp()then
for A,B in pairs(y.Arrow:GetChildren())do B.BackgroundTransparency=0 end else y.
BackgroundTransparency=1 for A,B in pairs(y.Arrow:GetChildren())do B.
BackgroundTransparency=0.5 end end if u:CanScrollDown()then for A,B in pairs(z.
Arrow:GetChildren())do B.BackgroundTransparency=0 end else z.
BackgroundTransparency=1 for A,B in pairs(z.Arrow:GetChildren())do B.
BackgroundTransparency=0.5 end end s(u)end p.UpdateMarkers=function(u)local v=u.
GuiElems.MarkerFrame v:ClearAllChildren()for w,x in pairs(u.Markers)do if w<u.
TotalSpace then o('Frame',{BackgroundTransparency=0,BackgroundColor3=x,
BorderSizePixel=0,Position=u.Horizontal and UDim2.new(w/u.TotalSpace,0,1,-6)or
UDim2.new(1,-6,w/u.TotalSpace,0),Size=u.Horizontal and UDim2.new(0,1,0,6)or
UDim2.new(0,6,0,1),Name='Marker'..tostring(w),Parent=v})end end end p.AddMarker=
function(u,v,w)u.Markers[v]=w or Color3.new(0,0,0)end p.ScrollTo=function(u,v,w)
u.Index=v u:Update()if not w then u.Scrolled:Fire()end end p.ScrollUp=function(u
)u.Index=u.Index-u.Increment u:Update()end p.ScrollDown=function(u)u.Index=u.
Index+u.Increment u:Update()end p.CanScrollUp=function(u)return u.Index>0 end p.
CanScrollDown=function(u)return u.Index+u.VisibleSpace<u.TotalSpace end p.
GetScrollPercent=function(u)return u.Index/(u.TotalSpace-u.VisibleSpace)end p.
SetScrollPercent=function(u,v)u.Index=math.floor(v*(u.TotalSpace-u.VisibleSpace)
)u:Update()end p.Texture=function(u,v)u.ThumbColor=v.ThumbColor or Color3.new(0,
0,0)u.ThumbSelectColor=v.ThumbSelectColor or Color3.new(0,0,0)u.GuiElems.
ScrollThumb.BackgroundColor3=v.ThumbColor or Color3.new(0,0,0)u.Gui.
BackgroundColor3=v.FrameColor or Color3.new(0,0,0)u.GuiElems.Button1.
BackgroundColor3=v.ButtonColor or Color3.new(0,0,0)u.GuiElems.Button2.
BackgroundColor3=v.ButtonColor or Color3.new(0,0,0)for w,x in pairs(u.GuiElems.
Button1.Arrow:GetChildren())do x.BackgroundColor3=v.ArrowColor or Color3.new(0,0
,0)end for w,x in pairs(u.GuiElems.Button2.Arrow:GetChildren())do x.
BackgroundColor3=v.ArrowColor or Color3.new(0,0,0)end end p.SetScrollFrame=
function(u,v)if u.ScrollUpEvent then u.ScrollUpEvent:Disconnect()u.ScrollUpEvent
=nil end if u.ScrollDownEvent then u.ScrollDownEvent:Disconnect()u.
ScrollDownEvent=nil end u.ScrollUpEvent=v.MouseWheelForward:Connect(function()u:
ScrollTo(u.Index-u.WheelIncrement)end)u.ScrollDownEvent=v.MouseWheelBackward:
Connect(function()u:ScrollTo(u.Index+u.WheelIncrement)end)end local u={}u.
__index=p local v=function(v)local w=setmetatable({Index=0,VisibleSpace=0,
TotalSpace=0,Increment=1,WheelIncrement=1,Markers={},GuiElems={},Horizontal=v,
LastTotalSpace=0,Scrolled=n.Signal.new()},u)w.Gui=t(w)w:Texture{ThumbColor=
Color3.fromRGB(60,60,60),ThumbSelectColor=Color3.fromRGB(75,75,75),ArrowColor=
Color3.new(1,1,1),FrameColor=Color3.fromRGB(40,40,40),ButtonColor=Color3.
fromRGB(75,75,75)}return w end return{new=v}end)()n.CodeFrame=(function()local p
,q,r,s,t,u,v,w={},{[1]='String',[2]='String',[3]='String',[4]='Comment',[5]=
'Operator',[6]='Number',[7]='Keyword',[8]='BuiltIn',[9]='LocalMethod',[10]=
'LocalProperty',[11]='Nil',[12]='Bool',[13]='Function',[14]='Local',[15]='Self',
[16]='FunctionName',[17]='Bracket'},{['nil']=11,['true']=12,['false']=12,[
'function']=13,['local']=14,self=15},{['and']=true,['break']=true,['do']=true,[
'else']=true,['elseif']=true,['end']=true,['false']=true,['for']=true,[
'function']=true,['if']=true,['in']=true,['local']=true,['nil']=true,['not']=
true,['or']=true,['repeat']=true,['return']=true,['then']=true,['true']=true,[
'until']=true,['while']=true,plugin=true},{delay=true,elapsedTime=true,require=
true,spawn=true,tick=true,time=true,typeof=true,UserSettings=true,wait=true,warn
=true,game=true,shared=true,script=true,workspace=true,assert=true,
collectgarbage=true,error=true,getfenv=true,getmetatable=true,ipairs=true,
loadstring=true,newproxy=true,next=true,pairs=true,pcall=true,print=true,
rawequal=true,rawget=true,rawset=true,select=true,setfenv=true,setmetatable=true
,tonumber=true,tostring=true,type=true,unpack=true,xpcall=true,_G=true,_VERSION=
true,coroutine=true,debug=true,math=true,os=true,string=true,table=true,bit32=
true,utf8=true,Axes=true,BrickColor=true,CFrame=true,Color3=true,ColorSequence=
true,ColorSequenceKeypoint=true,DockWidgetPluginGuiInfo=true,Enum=true,Faces=
true,Instance=true,NumberRange=true,NumberSequence=true,NumberSequenceKeypoint=
true,PathWaypoint=true,PhysicalProperties=true,Random=true,Ray=true,Rect=true,
Region3=true,Region3int16=true,TweenInfo=true,UDim=true,UDim2=true,Vector2=true,
Vector2int16=true,Vector3=true,Vector3int16=true,Drawing=true,syn=true,crypt=
true,cache=true,bit=true,readfile=true,writefile=true,isfile=true,appendfile=
true,listfiles=true,loadfile=true,isfolder=true,makefolder=true,delfolder=true,
delfile=true,setclipboard=true,setfflag=true,getnamecallmethod=true,isluau=true,
setnonreplicatedproperty=true,getspecialinfo=true,saveinstance=true,
rconsoleprint=true,rconsoleinfo=true,rconsolewarn=true,rconsoleerr=true,
rconsoleclear=true,rconsolename=true,rconsoleinput=true,rconsoleinputasync=true,
printconsole=true,checkcaller=true,islclosure=true,iscclosure=true,dumpstring=
true,decompile=true,hookfunction=true,newcclosure=true,isrbxactive=true,keypress
=true,keyrelease=true,mouse1click=true,mouse1press=true,mouse1release=true,
mouse2click=true,mouse2press=true,mouse2release=true,mousescroll=true,
mousemoveabs=true,mousemoverel=true,getrawmetatable=true,setrawmetatable=true,
setreadonly=true,isreadonly=true,getsenv=true,getcallingscript=true,getgenv=true
,getrenv=true,getreg=true,getgc=true,getinstances=true,getnilinstances=true,
getscripts=true,getloadedmodules=true,getconnections=true,firesignal=true,
fireclickdetector=true,firetouchinterest=true,fireproximityprompt=true},false,{[
"'"]='&apos;',['"']='&quot;',['<']='&lt;',['>']='&gt;',['&']='&amp;'},'\u{cd}'
local x,y,z,A,B,C=(' %s%s '):format(w,w),{[('[^%s] %s'):format(w,w)]=0,[(' %s%s'
):format(w,w)]=-1,[('%s%s '):format(w,w)]=2,[('%s [^%s]'):format(w,w)]=1},{},
function()local x,y,z=getfenv(),type,tostring for A,B in next,t do local C=x[A]
if y(C)=='table'then local D={}for E,F in next,C do D[E]=true end t[A]=D end end
local A,B={},Enum:GetEnums()for C=1,#B do A[z(B[C])]=true end t.Enum=A u=true
end,function(x)local y=x.GuiElems.EditBox y.Focused:Connect(function()x:
ConnectEditBoxEvent()x.Editing=true end)y.FocusLost:Connect(function()x:
DisconnectEditBoxEvent()x.Editing=false end)y:GetPropertyChangedSignal'Text':
Connect(function()local z=y.Text if#z==0 or x.EditBoxCopying then return end z=z
:gsub('\t','    ')y.Text=''x:AppendText(z)end)end,function(x)local y,z=x.
GuiElems.LinesFrame,x.Lines y.InputBegan:Connect(function(A)if A.UserInputType==
Enum.UserInputType.MouseButton1 then local B,C,D,E=math.ceil(x.FontSize/2),x.
FontSize,l.X-y.AbsolutePosition.X,l.Y-y.AbsolutePosition.Y local F,G,H,I,J,K,L=
math.round(D/B)+x.ViewX,math.floor(E/C)+x.ViewY,0,0 G=math.min(#z-1,G)local M=z[
G+1]or''F=math.min(#M,F+x:TabAdjust(F,G))x.SelectionRange={{-1,-1},{-1,-1}}x:
MoveCursor(F,G)x.FloatCursorX=F local N=function()local N,O=l.X-y.
AbsolutePosition.X,l.Y-y.AbsolutePosition.Y local P,Q=math.max(0,math.round(N/B)
+x.ViewX),math.max(0,math.floor(O/C)+x.ViewY)Q=math.min(#z-1,Q)local R=z[Q+1]or
''P=math.min(#R,P+x:TabAdjust(P,Q))if Q<G or(Q==G and P<F)then x.SelectionRange=
{{P,Q},{F,G}}else x.SelectionRange={{F,G},{P,Q}}end x:MoveCursor(P,Q)x.
FloatCursorX=P x:Refresh()end J=h.InputEnded:Connect(function(O)if O.
UserInputType==Enum.UserInputType.MouseButton1 then J:Disconnect()K:Disconnect()
L:Disconnect()x:SetCopyableSelection()end end)K=h.InputChanged:Connect(function(
O)if O.UserInputType==Enum.UserInputType.MouseMovement then local P,Q,R,S=l.Y-y.
AbsolutePosition.Y,l.Y-y.AbsolutePosition.Y-y.AbsoluteSize.Y,l.X-y.
AbsolutePosition.X,l.X-y.AbsolutePosition.X-y.AbsoluteSize.X H=0 I=0 if Q>0 then
H=math.floor(Q*0.05)+1 elseif P<0 then H=math.ceil(P*0.05)-1 end if S>0 then I=
math.floor(S*0.05)+1 elseif R<0 then I=math.ceil(R*0.05)-1 end N()end end)L=i.
RenderStepped:Connect(function()if H~=0 or I~=0 then x:ScrollDelta(I,H)N()end
end)x:Refresh()end end)end function p.MakeEditorFrame(D)local E=Instance.new
'TextButton'E.BackgroundTransparency=1 E.TextTransparency=1 E.BackgroundColor3=
Color3.fromRGB(40,40,40)E.BorderSizePixel=0 E.Size=UDim2.fromOffset(100,100)E.
Visible=true local F,G={},Instance.new'Frame'G.Name='Lines'G.
BackgroundTransparency=1 G.Size=UDim2.new(1,0,1,0)G.ClipsDescendants=true G.
Parent=E local H=Instance.new'TextLabel'H.Name='LineNumbers'H.
BackgroundTransparency=1 H.FontFace=D.FontFace H.TextXAlignment=Enum.
TextXAlignment.Right H.TextYAlignment=Enum.TextYAlignment.Top H.ClipsDescendants
=true H.RichText=true H.Parent=E f.Name='Cursor'f.BackgroundColor3=Color3.
fromRGB(220,220,220)f.BorderSizePixel=0 f.Parent=E local I=Instance.new'TextBox'
I.Name='EditBox'I.MultiLine=true I.Visible=false I.Parent=E I.TextSize=D.
FontSize I.FontFace=D.FontFace z.Invis=j:Create(f,TweenInfo.new(0,Enum.
EasingStyle.Quart,Enum.EasingDirection.Out),{BackgroundTransparency=1})z.Vis=j:
Create(f,TweenInfo.new(0,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{
BackgroundTransparency=0})local J=Instance.new'Frame'J.BackgroundColor3=Color3.
new(0.15686275064945,0.15686275064945,0.15686275064945)J.BorderSizePixel=0 J.
Name='ScrollCorner'J.Position=UDim2.new(1,-10,1,-10)J.Size=UDim2.new(0,10,0,10)J
.Visible=false F.ScrollCorner=J F.LinesFrame=G F.LineNumbersLabel=H F.Cursor=f F
.EditBox=I F.ScrollCorner.Parent=E G.InputBegan:Connect(function(K)if K.
UserInputType==Enum.UserInputType.MouseButton1 then D:SetEditing(true,K)end end)
D.Frame=E D.Gui=E D.GuiElems=F B(D)C(D)return E end p.GetSelectionText=function(
D)if not D:IsValidRange()then return''end local E=D.SelectionRange local F,G,H,I
=E[1][1],E[1][2],E[2][1],E[2][2]local J,K=I-G,D.Lines if not K[G+1]or not K[I+1]
then return''end if J==0 then return D:ConvertText(K[G+1]:sub(F+1,H),false)end
local L,M=K[G+1]:sub(F+1),K[I+1]:sub(1,H)local N=L..'\n'for O=G+1,I-1 do N=N..K[
O+1]..'\n'end N=N..M return D:ConvertText(N,false)end p.SetCopyableSelection=
function(D)local E,F=D:GetSelectionText(),D.GuiElems.EditBox D.EditBoxCopying=
true F.Text=E F.SelectionStart=1 F.CursorPosition=#F.Text+1 D.EditBoxCopying=
false end p.ConnectEditBoxEvent=function(D)if D.EditBoxEvent then D.EditBoxEvent
:Disconnect()end D.EditBoxEvent=h.InputBegan:Connect(function(E)if E.
UserInputType~=Enum.UserInputType.Keyboard then return end local F,G,H=Enum.
KeyCode,E.KeyCode,function(F,G)local H,I H=h.InputEnded:Connect(function(J)if J.
KeyCode~=F then return end H:Disconnect()I=true end)G()n.FastWait(0.5)while not
I do G()n.FastWait(0.03)end end if G==F.Down then H(F.Down,function()D.CursorX=D
.FloatCursorX D.CursorY=D.CursorY+1 D:UpdateCursor()D:JumpToCursor()end)elseif G
==F.Up then H(F.Up,function()D.CursorX=D.FloatCursorX D.CursorY=D.CursorY-1 D:
UpdateCursor()D:JumpToCursor()end)elseif G==F.Left then H(F.Left,function()local
I=D.Lines[D.CursorY+1]or''D.CursorX=D.CursorX-1-(I:sub(D.CursorX-3,D.CursorX)==x
and 3 or 0)if D.CursorX<0 then D.CursorY=D.CursorY-1 local J=D.Lines[D.CursorY+1
]or''D.CursorX=#J end D.FloatCursorX=D.CursorX D:UpdateCursor()D:JumpToCursor()
end)elseif G==F.Right then H(F.Right,function()local I=D.Lines[D.CursorY+1]or''D
.CursorX=D.CursorX+1+(I:sub(D.CursorX+1,D.CursorX+4)==x and 3 or 0)if D.CursorX>
#I then D.CursorY=D.CursorY+1 D.CursorX=0 end D.FloatCursorX=D.CursorX D:
UpdateCursor()D:JumpToCursor()end)elseif G==F.Backspace then H(F.Backspace,
function()local I,J if D:IsValidRange()then I=D.SelectionRange[1]J=D.
SelectionRange[2]else J={D.CursorX,D.CursorY}end if not I then local K=D.Lines[D
.CursorY+1]or''D.CursorX=D.CursorX-1-(K:sub(D.CursorX-3,D.CursorX)==x and 3 or 0
)if D.CursorX<0 then D.CursorY=D.CursorY-1 local L=D.Lines[D.CursorY+1]or''D.
CursorX=#L end D.FloatCursorX=D.CursorX D:UpdateCursor()I=I or{D.CursorX,D.
CursorY}end D:DeleteRange({I,J},false,true)D:ResetSelection(true)D:JumpToCursor(
)end)elseif G==F.Delete then H(F.Delete,function()local I,J if D:IsValidRange()
then I=D.SelectionRange[1]J=D.SelectionRange[2]else I={D.CursorX,D.CursorY}end
if not J then local K=D.Lines[D.CursorY+1]or''local L,M=D.CursorX+1+(K:sub(D.
CursorX+1,D.CursorX+4)==x and 3 or 0),D.CursorY if L>#K then M=M+1 L=0 end D:
UpdateCursor()J=J or{L,M}end D:DeleteRange({I,J},false,true)D:ResetSelection(
true)D:JumpToCursor()end)elseif h:IsKeyDown(Enum.KeyCode.LeftControl)then if G==
F.A then D.SelectionRange={{0,5},{#D.Lines[#D.Lines],#D.Lines-1}}D:
SetCopyableSelection()D:Refresh()end end end)end p.DisconnectEditBoxEvent=
function(D)if D.EditBoxEvent then D.EditBoxEvent:Disconnect()f.
BackgroundTransparency=1 p.CursorAnim(D,false)end end p.ResetSelection=function(
D,E)D.SelectionRange={{-1,-1},{-1,-1}}if not E then D:Refresh()end end p.
IsValidRange=function(D,E)local F=E or D.SelectionRange local G,H,I,J=F[1][1],F[
1][2],F[2][1],F[2][2]if G==-1 or(G==I and H==J)then return false end return true
end p.DeleteRange=function(D,E,F,G)E=E or D.SelectionRange if not D:
IsValidRange(E)then return end local H,I,J,K,L=D.Lines,E[1][1],E[1][2],E[2][1],E
[2][2]local M=L-J if not H[J+1]or not H[L+1]then return end local N,O=H[J+1]:
sub(1,I),H[L+1]:sub(K+1)H[J+1]=N..O local P=table.remove for Q=1,M do P(H,J+2)
end if E==D.SelectionRange then D.SelectionRange={{-1,-1},{-1,-1}}end if G then
D.CursorX=I D.CursorY=J D:UpdateCursor()end if not F then D:ProcessTextChange()
end end p.AppendText=function(D,E)D:DeleteRange(nil,true,true)local F,G,H=D.
Lines,D.CursorX,D.CursorY local I=F[H+1]local J,K=I:sub(1,G),I:sub(G+1)E=E:gsub(
'\r\n','\n')E=D:ConvertText(E,true)local L,M=E:split'\n',table.insert for N=1,#L
do local O=H+N if N>1 then M(F,O,'')end local P,Q,R=L[N],(N==1 and J or''),(N==#
L and K or'')F[O]=Q..P..R end if#L>1 then G=0 end D:ProcessTextChange()D.CursorX
=G+#L[#L]D.CursorY=H+#L-1 D:UpdateCursor()end p.ScrollDelta=function(D,E,F)D.
ScrollV:ScrollTo(D.ScrollV.Index+F)D.ScrollH:ScrollTo(D.ScrollH.Index+E)end p.
TabAdjust=function(D,E,F)local G=D.Lines local H=G[F+1]E=E+1 if H then local I,J
,K=H:sub(E-1,E-1),H:sub(E,E),H:sub(E+1,E+1)local L=(#I>0 and I or' ')..(#J>0 and
J or' ')..(#K>0 and K or' ')for M,N in pairs(y)do if L:find(M)then return N end
end end return 0 end p.SetEditing=function(D,E,F)if F then D:UpdateCursor(F)end
if E then if D.Editable then D.GuiElems.EditBox.Text=''D.GuiElems.EditBox:
CaptureFocus()end else D.GuiElems.EditBox:ReleaseFocus()end end p.CursorAnim=
function(D,E)local F,G=D.GuiElems.Cursor,tick()D.LastAnimTime=G if not E then
return end z.Invis:Cancel()z.Vis:Cancel()F.BackgroundTransparency=0 coroutine.
wrap(function()while D.Editable do n.FastWait(0.5)if D.LastAnimTime~=G then
return end z.Invis:Play()n.FastWait(0.5)if D.LastAnimTime~=G then return end z.
Vis:Play()end end)()end p.MoveCursor=function(D,E,F)D.CursorX=E D.CursorY=F D:
UpdateCursor()D:JumpToCursor()end p.JumpToCursor=function(D)D:Refresh()end p.
UpdateCursor=function(D,E)local F,G=D.GuiElems.LinesFrame,D.GuiElems.Cursor
local H,I=math.max(0,F.AbsoluteSize.X),math.max(0,F.AbsoluteSize.Y)local J,K,L,M
,N,O=math.ceil(I/D.FontSize),math.ceil(H/math.ceil(D.FontSize/2)),D.ViewX,D.
ViewY,tostring(#D.Lines),math.ceil(D.FontSize/2)local P=#N*O+4*O if E then local
Q=D.GuiElems.LinesFrame local R,S,T,U,V,W=Q.AbsolutePosition.X,Q.
AbsolutePosition.Y,E.Position.X,E.Position.Y,math.ceil(D.FontSize/2),D.FontSize
D.CursorX=D.ViewX+math.round((T-R)/V)D.CursorY=D.ViewY+math.floor((U-S)/W)end
local Q,R=D.CursorX,D.CursorY local S=D.Lines[R+1]or''if Q>#S then Q=#S elseif Q
<0 then Q=0 end if R>=#D.Lines then R=math.max(0,#D.Lines-1)elseif R<0 then R=0
end Q=Q+D:TabAdjust(Q,R)D.CursorX=Q D.CursorY=R local T=(Q>=L)and(R>=M)and(Q<=L+
K)and(R<=M+J)if T then local U,V=(Q-L),(R-M)G.Position=UDim2.new(0,P+U*math.
ceil(D.FontSize/2)-1,0,V*D.FontSize)G.Size=UDim2.new(0,1,0,D.FontSize+2)G.
Visible=true D:CursorAnim(true)else G.Visible=false end end p.MapNewLines=
function(D)local E,F,G,H,I={},1,D.Text,string.find,1 local J=H(G,'\n',I,true)
while J do E[F]=J F=F+1 I=J+1 J=H(G,'\n',I,true)end D.NewLines=E end p.
PreHighlight=function(D)local E=D.Text:gsub('\\\\','  ')local F,G,H,I,J,K=#E,{},
{},{},string.find,string.sub D.ColoredLines={}local L=function(L,M,N,O)local P,Q
=#G+1,1 local R,S,T=J(L,M,Q,O)while R do G[P]=R H[R]=N if T then I[R]=T end P=P+
1 Q=S+1 R,S,T=J(L,M,Q,O)end end L(E,'"',1,true)L(E,"'",2,true)L(E,'%[(=*)%[',3)
L(E,'--',4,true)table.sort(G)local M,N,O,P,Q=D.NewLines,0,0,0,{}for R=1,#G do
local S=G[R]if S<=P then continue end local T,U=S,H[S]if U==1 then T=J(E,'"',S+1
,true)while T and K(E,T-1,T-1)=='\\'do T=J(E,'"',T+1,true)end if not T then T=F
end elseif U==2 then T=J(E,"'",S+1,true)while T and K(E,T-1,T-1)=='\\'do T=J(E,
"'",T+1,true)end if not T then T=F end elseif U==3 then _,T=J(E,']'..I[S]..']',S
+1,true)if not T then T=F end elseif U==4 then local V=H[S+2]if V==3 then _,T=J(
E,']'..I[S+2]..']',S+1,true)if not T then T=F end else T=J(E,'\n',S+1,true)or F
end end while S>O do N=N+1 O=M[N]or F+1 end while true do local V=Q[N]if not V
then V={}Q[N]=V end V[S]={U,T}if T>O then N=N+1 O=M[N]or F+1 else break end end
P=T end D.PreHighlights=Q end p.HighlightLine=function(D,E)local F=D.
ColoredLines[E]if F then return F end local G,H,I,J,K,L,M,N,O,P,Q,R,S=string.sub
,string.find,string.match,{},D.PreHighlights[E]or{},D.Lines[E]or'',0,0,false,0,D
.NewLines[E-1]or 0,{}for T,U in next,K do local V=T-Q if V<1 then N=U[1]M=U[2]-Q
else R[V]={U[1],U[2]-Q}end end for T=1,#L do if T<=M then J[T]=N continue end
local U=R[T]if U then N=U[1]M=U[2]J[T]=N O=false S=nil P=0 else local V=G(L,T,T)
if H(V,'[%a_]')then local W=I(L,'[%a%d_]+',T)local X=(s[W]and 7)or(t[W]and 8)M=T
+#W-1 if X~=7 then if O then local Y=S and t[S]X=(Y and type(Y)=='table'and Y[W]
and 8)or 10 end if X~=8 then local Y,Z,_=H(L,'^%s*([%({"\'])',M+1)if Y then X=(P
>0 and _=='('and 16)or 9 P=0 end end else X=r[W]or X P=(W=='function'and 1 or 0)
end S=W O=false if P>0 then P=1 end if X then N=X J[T]=N else N=nil end elseif
H(V,'%p')then local W=(V=='.')local X=W and H(G(L,T+1,T+1),'%d')J[T]=(X and 6 or
5)if not X then local Y=W and I(L,'%.%.?%.?',T)if Y and#Y>1 then N=5 M=T+#Y-1 O=
false S=nil P=0 else if W then if O then S=nil else O=true end else O=false S=
nil end P=((W or V==':')and P==1 and 2)or 0 end end elseif H(V,'%d')then local W
,X=H(L,'%x+',T)local Y=G(L,X,X+1)if(Y=='e+'or Y=='e-')and H(G(L,X+2,X+2),'%d')
then X=X+1 end N=6 M=X J[T]=6 O=false S=nil P=0 else J[T]=N local W,X=H(L,'%s+',
T)if X then M=X end end end end D.ColoredLines[E]=J return J end p.Refresh=
function(D)local E=D.Frame.Lines local F,G=math.max(0,E.AbsoluteSize.X),math.
max(0,E.AbsoluteSize.Y)local H,I,J,K,L,M,N=math.ceil(G/D.FontSize),math.ceil(F/
math.ceil(D.FontSize/2)),string.gsub,string.sub,D.ViewX,D.ViewY,''for O=1,H do
local P=D.LineFrames[O]if not P then P=Instance.new'Frame'P.Name='Line'P.
Position=UDim2.new(0,0,0,(O-1)*D.FontSize)P.Size=UDim2.new(1,0,0,D.FontSize)P.
BorderSizePixel=0 P.BackgroundTransparency=1 local Q=Instance.new'Frame'Q.Name=
'SelectionHighlight'Q.BorderSizePixel=0 Q.BackgroundColor3=d.Theme.Syntax.
SelectionBack Q.Parent=P Q.BackgroundTransparency=0.7 local R=Instance.new
'TextLabel'R.Name='Label'R.BackgroundTransparency=1 R.FontFace=D.FontFace R.
TextSize=D.FontSize R.Size=UDim2.new(1,0,0,D.FontSize)R.RichText=true R.
TextXAlignment=Enum.TextXAlignment.Left R.TextColor3=D.Colors.Text R.ZIndex=2 R.
Parent=P P.Parent=E D.LineFrames[O]=P end local Q=M+O local R,S,T,U,V=D.Lines[Q]
or'','',D:HighlightLine(Q),L+1,D.RichTemplates local W,X,Y=V.Text,V.Selection,T[
U]local Z,_=V[q[Y] ]or W,D.SelectionRange local aa,ab,ac=_[1],_[2],Q-1 if ac>=aa
[2]and ac<=ab[2]then local ad,ae=math.ceil(D.FontSize/2),(ac==aa[2]and aa[1]or 0
)-L local af=(ac==ab[2]and ab[1]-ae-L or I+L)P.SelectionHighlight.Position=UDim2
.new(0,ae*ad,0,0)P.SelectionHighlight.Size=UDim2.new(0,af*ad,1,0)P.
SelectionHighlight.Visible=true else P.SelectionHighlight.Visible=false end for
ad=2,I do local ae=L+ad local af=T[ae]if af~=Y then local ag=V[q[af] ]or W if ag
~=Z then local ah=J(K(R,U,ae-1),'[\'"<>&]',v)S=S..(Z~=W and(Z..ah..'</font>')or
ah)U=ae Z=ag end Y=af end end local ad=J(K(R,U,L+I),'[\'"<>&]',v)if#ad>0 then S=
S..(Z~=W and(Z..ad..'</font>')or ad)end if D.Lines[Q]then N=N..(Q-1==D.CursorY
and('<b>'..Q..'</b>\n')or Q..'\n')end P.Label.Text=S end for aa=H+1,#D.
LineFrames do D.LineFrames[aa]:Destroy()D.LineFrames[aa]=nil end D.Frame.
LineNumbers.Text=N D:UpdateCursor()end p.UpdateView=function(aa)local ab,ac=
tostring(#aa.Lines),math.ceil(aa.FontSize/2)local ad,ae=#ab*ac+4*ac,aa.Frame.
Lines local af,ag=ae.AbsoluteSize.X,ae.AbsoluteSize.Y local ah,D,E,F=math.ceil(
ag/aa.FontSize),aa.MaxTextCols*ac,aa.ScrollV,aa.ScrollH E.VisibleSpace=ah E.
TotalSpace=#aa.Lines+1 F.VisibleSpace=math.ceil(af/ac)F.TotalSpace=aa.
MaxTextCols+1 E.Gui.Visible=#aa.Lines+1>ah F.Gui.Visible=D>af local G=aa.
FrameOffsets aa.FrameOffsets=Vector2.new(E.Gui.Visible and-10 or 0,F.Gui.Visible
and-10 or 0)if G~=aa.FrameOffsets then aa:UpdateView()else E:ScrollTo(aa.ViewY,
true)F:ScrollTo(aa.ViewX,true)if E.Gui.Visible and F.Gui.Visible then E.Gui.Size
=UDim2.new(0,10,1,-10)F.Gui.Size=UDim2.new(1,-10,0,10)aa.GuiElems.ScrollCorner.
Visible=true else E.Gui.Size=UDim2.new(0,10,1,0)F.Gui.Size=UDim2.new(1,0,0,10)aa
.GuiElems.ScrollCorner.Visible=false end aa.ViewY=E.Index aa.ViewX=F.Index aa.
Frame.Lines.Position=UDim2.new(0,ad,0,0)aa.Frame.Lines.Size=UDim2.new(1,-ad+G.X,
1,G.Y)aa.Frame.LineNumbers.Position=UDim2.new(0,ac,0,0)aa.Frame.LineNumbers.Size
=UDim2.new(0,#ab*ac,1,G.Y)aa.Frame.LineNumbers.TextSize=aa.FontSize end end p.
ProcessTextChange=function(aa)local ab,ac=0,aa.Lines for ad=1,#ac do local ae=#
ac[ad]if ae>ab then ab=ae end end aa.MaxTextCols=ab aa:UpdateView()aa.Text=table
.concat(aa.Lines,'\n')aa:MapNewLines()aa:PreHighlight()aa:Refresh()end p.
ConvertText=function(aa,ab,ac)if ac then local ad=ab:gsub('\t','    ')return ad:
gsub('\t',(' %s%s '):format(w,w))else return ab:gsub((' %s%s '):format(w,w),'\t'
)end end p.GetText=function(aa)local ab=table.concat(aa.Lines,'\n')return aa:
ConvertText(ab,false)end p.SetText=function(aa,ab)ab=aa:ConvertText(ab,true)
local ac=aa.Lines table.clear(ac)local ad=1 for ae in ab:gmatch
'([^\n\r]*)[\n\r]?'do ac[ad]=ae ad=ad+1 end aa:ProcessTextChange()end p.
ClearText=function(aa)local ab,ac=aa:ConvertText('',true),aa.Lines table.clear(
ac)local ad=1 for ae in ab:gmatch'([^\n\r]*)[\n\r]?'do ac[ad]=ae ad=ad+1 end aa:
ProcessTextChange()end p.CompileText=function(aa)local ab=pcall(function()local
ab=table.concat(aa.Lines,'\n')local ac=aa:ConvertText(ab,false)loadstring(ac)()
end)return ab end p.ReturnErrors=function(aa)local ab,ac=pcall(function()local
ab=table.concat(aa.Lines,'\n')local ac=aa:ConvertText(ab,false)loadstring(ac)()
end)return not ab and ac or nil end p.GetVersion=function(aa)return b end p.
MakeRichTemplates=function(aa)local ab,ac=math.floor,{}for ad,ae in pairs(aa.
Colors)do ac[ad]=('<font color="rgb(%s,%s,%s)">'):format(ab(ae.r*255),ab(ae.g*
255),ab(ae.b*255))end aa.RichTemplates=ac end p.ApplyTheme=function(aa)local ab=
d.Theme.Syntax aa.Colors=ab aa.Frame.LineNumbers.TextColor3=ab.Text aa.Frame.
BackgroundColor3=ab.Background end local aa={__index=p}local ab=function(ab)ab=
ab or{}if not u then A()end local ac,ad=n.ScrollBar.new(),n.ScrollBar.new(true)
ad.Gui.Position=UDim2.new(0,0,1,-10)local ae={FontFace=Font.fromEnum(Enum.Font.
Code),FontSize=14,ViewX=0,ViewY=0,Colors=d.Theme.Syntax,ColoredLines={},Lines={
''},LineFrames={},Editable=true,Editing=false,CursorX=0,CursorY=0,FloatCursorX=0
,Text='',PreHighlights={},SelectionRange={{-1,-1},{-1,-1}},NewLines={},
FrameOffsets=Vector2.new(0,0),MaxTextCols=0,ScrollV=ac,ScrollH=ad}local af=m(ae,
ab)local ag=setmetatable(af,aa)p.SetTextMultiplier=(function(ah)ag.FontSize=ah
end)p.GetTextMultiplier=(function()return ag.FontSize end)ac.WheelIncrement=3 ad
.Increment=2 ad.WheelIncrement=7 ac.Scrolled:Connect(function()ag.ViewY=ac.Index
ag:Refresh()end)ad.Scrolled:Connect(function()ag.ViewX=ad.Index ag:Refresh()end)
ag:MakeEditorFrame(ag)ag:MakeRichTemplates()ag:ApplyTheme()ac:SetScrollFrame(ag.
Frame.Lines)ac.Gui.Parent=ag.Frame ad.Gui.Parent=ag.Frame ag:UpdateView()ag:
SetText(af.Text)ag.Frame:GetPropertyChangedSignal'AbsoluteSize':Connect(function
()ag:UpdateView()ag:Refresh()end)return ag end return{new=ab}end)()return n end
function a.b()local aa,ab,ac={Services={},OnInitConnections={}},get_hidden_gui
or gethui,cloneref or function(aa)return aa end local ad=aa.Services
setmetatable(ad,{__index=function(ae,af)local ag=game:GetService(af)return ac(ag
)end})local ae,af=(ad.CoreGui)function aa:AddOnInit(ag)local ah=self.
OnInitConnections table.insert(ah,ag)end function aa:CallOnInitConnections(ag,
...)local ah=self.OnInitConnections af=ag for b,c in next,ah do c(af,...)end end
function aa:SetProperties(ag,ah)for b,c in next,ah do pcall(function()ag[b]=c
end)end end function aa:NewClass(ag,ah)ah=ah or{}ag.__index=ag return
setmetatable(ah,ag)end function aa:CheckConfig(ag,ah,b,c)if not ag then return
end for d,e in next,ah do if ag[d]~=nil then continue end if c then if table.
find(c,d)then continue end end if b then e=e()end ag[d]=e end return ag end
function aa:ResolveUIParent()local ag,ah=af.PlayerGui,af.Debug local b,c={[1]=
function()local b=ab()if b.Parent==ae then return end return b end,[2]=function(
)return ae end,[3]=function()return ag end},af:CreateInstance'ScreenGui'for d,e
in next,b do local f,g=pcall(e)if not f or not g then continue end local h=
pcall(function()c.Parent=g end)if not h then continue end if ah then af:Warn(`Step: {
d} was chosen as the parent!: {g}`)end return g end af:Warn
'The ReGui container does not have a parent defined'return nil end function aa:
GetChildOfClass(ag,ah)local b=ag:FindFirstChildOfClass(ah)if not b then b=af:
CreateInstance(ah,ag)end return b end function aa:CheckAssetUrl(ag)if tonumber(
ag)then return`rbxassetid://{ag}`end return ag end function aa:SetPadding(ag,ah)
if not ag then return end self:SetProperties(ag,{PaddingBottom=ah,PaddingLeft=ah
,PaddingRight=ah,PaddingTop=ah})end return aa end function a.c()local aa,ab=a.
load'b',{DefaultTweenInfo=TweenInfo.new(0.08)}local ac=aa.Services local ad=ac.
TweenService function ab:Tween(ae)local af,ag,ah=self.DefaultTweenInfo,ae.Object
,ae.NoAnimation local b,c,d,e=ae.Tweeninfo or af,ae.EndProperties,ae.
StartProperties,ae.Completed if d then aa:SetProperties(ag,d)end if ah then aa:
SetProperties(ag,c)if e then e()end return end local f for g,h in next,c do
local i={[g]=h}local j,k=pcall(function()return ad:Create(ag,b,i)end)if not j
then aa:SetProperties(ag,i)continue end if not f then f=k end k:Play()end if e
then if f then f.Completed:Connect(e)else e()end end return f end function ab:
Animate(ae)local af,ag,ah,b,c=ae.NoAnimation,ae.Objects,ae.Tweeninfo,(ae.
Completed)for d,e in next,ag do local f=self:Tween{NoAnimation=af,Object=d,
Tweeninfo=ah,EndProperties=e}if not c then c=f end end if b then c.Completed:
Connect(b)end return c end function ab:HeaderCollapseToggle(ae)aa:CheckConfig(ae
,{Rotations={Open=90,Closed=0}})local af,ag,ah,b,c=ae.Toggle,ae.NoAnimation,ae.
Rotations,ae.Collapsed,ae.Tweeninfo local d=b and ah.Closed or ah.Open self:
Tween{Tweeninfo=c,NoAnimation=ag,Object=af,EndProperties={Rotation=d}}end
function ab:HeaderCollapse(ae)local af,ag,ah,b,c,d,e,f,g,h,i=ae.Tweeninfo,ae.
Collapsed,ae.ClosedSize,ae.OpenSize,ae.Toggle,ae.Resize,ae.Hide,ae.NoAnimation,
ae.NoAutomaticSize,ae.IconRotations,ae.Completed if not g then d.AutomaticSize=
Enum.AutomaticSize.None end if not ag then e.Visible=true end self:
HeaderCollapseToggle{Tweeninfo=af,Collapsed=ag,NoAnimation=f,Toggle=c,Rotations=
h}local j=self:Tween{Tweeninfo=af,NoAnimation=f,Object=d,StartProperties={Size=
ag and b or ah},EndProperties={Size=ag and ah or b},Completed=function()e.
Visible=not ag if i then i()end if ag then return end if g then return end d.
Size=UDim2.fromScale(1,0)d.AutomaticSize=Enum.AutomaticSize.Y end}return j end
return ab end function a.d()local aa={}aa.__index=aa local ab=a.load'b'function
aa:Fire(...)local ac=self:GetConnections()if#ac<=0 then return end for ad,ae in
next,ac do ae(...)end end function aa:GetConnections()local ac=self.Connections
return ac end function aa:Connect(ac)local ad=self:GetConnections()table.insert(
ad,ac)end function aa:DisconnectConnections()local ac=self:GetConnections()table
.clear(ac)end function aa:NewSignal()return ab:NewClass(aa,{Connections={}})end
return aa end function a.e()return function(aa)local ab=aa:Window{Title=
'Configuration saving',Size=UDim2.fromOffset(300,200)}local ac,ad=(ab:Row())ac:
Button{Text='Dump Ini',Callback=function()print(aa:DumpIni(true))end}ac:Button{
Text='Save Ini',Callback=function()ad=aa:DumpIni(true)end}ac:Button{Text=
'Load Ini',Callback=function()if not ad then warn'No save data!'return end aa:
LoadIni(ad,true)end}ab:Separator()ab:SliderInt{IniFlag='MySlider',Value=5,
Minimum=1,Maximum=32}ab:Checkbox{IniFlag='MyCheckbox',Value=true}ab:InputText{
IniFlag='MyInput',Value='Hello world!'}ab:Keybind{IniFlag='MyKeybind',Label=
'Keybind (w/ Q & Left-Click blacklist)',KeyBlacklist={Enum.UserInputType.
MouseButton1,Enum.KeyCode.Q}}local ae=aa:TabsWindow{Title='Tabs window!',Visible
=false,Size=UDim2.fromOffset(300,200)}for af,ag in{'Avocado','Broccoli',
'Cucumber'}do local ah=ae:CreateTab{Name=ag}ah:Label{Text=`This is the {ag} tab!`
}end local af=aa.Elements:Label{Parent=aa.Container.Windows,Visible=false,
UiPadding=UDim.new(0,8),CornerRadius=UDim.new(0,2),Position=UDim2.fromOffset(10,
10),Size=UDim2.fromOffset(250,50),Border=true,BorderThickness=1,BorderColor=aa.
Accent.Gray,BackgroundTransparency=0.4,BackgroundColor3=aa.Accent.Black}game:
GetService'RunService'.RenderStepped:Connect(function(ag)local ah,b,c=math.
round(1/ag),DateTime.now():FormatLocalTime('dddd h:mm:ss A','en-us'),`ReGui {aa:
GetVersion()}\n`c..=`FPS: {ah}\n`c..=`The time is {b}`af.Text=c end)local ag=aa:
Window{Title='Dear ReGui Demo',Size=UDim2.new(0,400,0,300),NoScroll=true}:
Center()local ah=ag:MenuBar()local b=ah:MenuItem{Text='Menu'}b:Selectable{Text=
'New'}b:Selectable{Text='Open'}b:Selectable{Text='Save'}b:Selectable{Text=
'Save as'}b:Selectable{Text='Exit',Callback=function()ag:Close()end}local c=ah:
MenuItem{Text='Examples'}c:Selectable{Text='Print hello world',Callback=function
()print'Hello world!'end}c:Selectable{Text='Tabs window',Callback=function()ae:
ToggleVisibility()end}c:Selectable{Text='Configuration saving',Callback=function
()ab:ToggleVisibility()end}c:Selectable{Text='Watermark',Callback=function()af.
Visible=not af.Visible end}ag:Label{Text=`Dear ReGui says hello! ({aa:
GetVersion()})`}local d=ag:ScrollingCanvas{Fill=true,UiPadding=UDim.new(0,0)}
local e=d:CollapsingHeader{Title='Help'}e:Separator{Text='ABOUT THIS DEMO:'}e:
BulletText{Rows={
[[Sections below are demonstrating many aspects of the library.]]}}e:Separator{
Text='PROGRAMMER GUIDE:'}e:BulletText{Rows={
[[See example FAQ, examples, and documentation at https://depso.gitbook.io/regui]]
}}e:Indent():BulletText{Rows={'See example applications in the /demo folder.'}}
local f=d:CollapsingHeader{Title='Configuration'}local g=f:TreeNode{Title=
'Backend Flags'}g:Checkbox{Label='ReGui:IsMobileDevice',Disabled=true,Value=aa:
IsMobileDevice()}g:Checkbox{Label='ReGui:IsConsoleDevice',Disabled=true,Value=aa
:IsConsoleDevice()}local h=f:TreeNode{Title='Style'}h:Combo{Selected='DarkTheme'
,Label='Colors',Items=aa.ThemeConfigs,Callback=function(i,j)ag:SetTheme(j)end}
local i,j=d:CollapsingHeader{Title='Window options'}:Table{MaxColumns=3}:
NextRow(),{NoResize=false,NoTitleBar=false,NoClose=false,NoCollapse=false,
OpenOnDoubleClick=true,NoBringToFrontOnFocus=false,NoMove=false,NoSelect=false,
NoScrollBar=false,NoBackground=false}for k,l in pairs(j)do local m=i:NextColumn(
)m:Checkbox{Value=l,Label=k,Callback=function(n,o)ag:UpdateConfig{[k]=o}end}end
local k,l,p=d:CollapsingHeader{Title='Widgets'},{'Basic','Tooltips','Tree Nodes'
,'Collapsing Headers','Bullets','Text','Images','Videos','Combo','Tabs',
'Plot widgets','Multi-component Widgets','Progress Bars','Picker Widgets',
'Code editor','Console','List layout','Indent','Viewport','Keybinds','Input',
'Text Input'},{Basic=function(k)k:Separator{Text='General'}local l=k:Row()local
m=l:Label{Text='Thanks for clicking me!',Visible=false,LayoutOrder=2}l:Button{
Callback=function()m.Visible=not m.Visible end}k:Checkbox()local n=k:Row()n:
Radiobox{Label='radio a'}n:Radiobox{Label='radio b'}n:Radiobox{Label='radio c'}
local o=k:Row()for p=1,7 do local q=p/7 o:Button{Text='Click',BackgroundColor3=
Color3.fromHSV(q,0.6,0.6)}end local p=k:Button{Text='Tooltip'}aa:SetItemTooltip(
p,function(q)q:Label{Text='I am a tooltip'}end)k:Separator{Text='Inputs'}k:
InputText{Value='Hello world!'}k:InputText{Placeholder='Enter text here',Label=
'Input text (w/ hint)',Value=''}k:InputInt{Value=50}k:InputInt{Label=
'Input Int (w/ limit)',Value=5,Maximum=10,Minimum=1}k:Separator{Text='Drags'}k:
DragInt()k:DragInt{Maximum=100,Minimum=0,Label='Drag Int 0..100',Format='%d%%'}k
:DragFloat{Maximum=1,Minimum=0,Value=0.5}k:Separator{Text='Sliders'}k:SliderInt{
Format='%.d/%s',Value=5,Minimum=1,Maximum=32,ReadOnly=false}:SetValue(8)k:
SliderInt{Label='Slider Int (w/ snap)',Value=1,Minimum=1,Maximum=8,Type='Snap'}k
:SliderFloat{Label='Slider Float',Minimum=0,Maximum=1,Format='Ratio = %.3f'}k:
SliderFloat{Label='Slider Angle',Minimum=-360,Maximum=360,Format='%.f deg'}k:
SliderEnum{Items={'Fire','Earth','Air','Water'},Value=2}k:SliderEnum{Items={
'Fire','Earth','Air','Water'},Value=2,Disabled=true,Label='Disabled Enum'}k:
SliderProgress{Label='Progress Slider',Value=8,Minimum=1,Maximum=32}k:Separator{
Text='Selectors/Pickers'}k:InputColor3{Value=aa.Accent.Light,Label='Color 1'}k:
SliderColor3{Value=aa.Accent.Light,Label='Color 2'}k:InputCFrame{Value=CFrame.
new(1,1,1),Minimum=CFrame.new(0,0,0),Maximum=CFrame.new(200,100,50),Label=
'CFrame 1'}k:SliderCFrame{Value=CFrame.new(1,1,1),Minimum=CFrame.new(0,0,0),
Maximum=CFrame.new(200,100,50),Label='CFrame 2'}k:Combo{Selected=1,Items={'AAAA'
,'BBBB','CCCC','DDDD','EEEE','FFFF','GGGG','HHHH','IIIIIII','JJJJ','KKKKKKK'}}
end,Tooltips=function(k)k:Separator{Text='General'}local l=k:Button{Text='Basic'
,Size=UDim2.fromScale(1,0)}aa:SetItemTooltip(l,function(m)m:Label{Text=
'I am a tooltip'}end)local m=k:Button{Text='Fancy',Size=UDim2.fromScale(1,0)}aa:
SetItemTooltip(m,function(n)n:Label{Text='I am a fancy tooltip'}n:Image{Image=
18395893036}local o=n:Label()while wait()do o.Text=`Sin(time) = {math.sin(tick()
)}`end end)local n=k:Button{Text='Double tooltip',Size=UDim2.fromScale(1,0)}for
o=1,3 do aa:SetItemTooltip(n,function(p)p:Label{Text=`I am tooltip {o}`}end)end
end,Videos=function(k)local l=k:VideoPlayer{Video=5608327482,Looped=true,Ratio=
1.7777777777777777,RatioAspectType=Enum.AspectType.FitWithinMaxSize,RatioAxis=
Enum.DominantAxis.Width,Size=UDim2.fromScale(1,1)}l:Play()local n=k:Row{Expanded
=true}n:Button{Text='Pause',Callback=function()l:Pause()end}n:Button{Text='Play'
,Callback=function()l:Play()end}if not l.IsLoaded then l.Loaded:Wait()end local
o=n:SliderInt{Format='%.f',Value=0,Minimum=0,Maximum=l.TimeLength,Callback=
function(o,p)l.TimePosition=p end}game:GetService'RunService'.RenderStepped:
Connect(function(p)o:SetValue(l.TimePosition)end)end,['Tree Nodes']=function(k)
for l=1,5 do local n=k:TreeNode{Title=`Child {l}`,Collapsed=l~=1}local o=n:Row()
o:Label{Text='Blah blah'}o:SmallButton{Text='Button'}end k:TreeNode{Title=`With icon & NoArrow`
,NoArrow=true,Icon=aa.Icons.Image}end,['Collapsing Headers']=function(k)local l
k:Checkbox{Value=true,Label='Show 2nd header',Callback=function(n,o)if l then l:
SetVisible(o)end end}k:Checkbox{Value=true,Label='2nd has arrow',Callback=
function(n,o)if l then l:SetArrowVisible(o)end end}local n=k:CollapsingHeader{
Title='Header'}for o=1,5 do n:Label{Text=`Some content {o}`}end l=k:
CollapsingHeader{Title='Second Header'}for o=1,5 do l:Label{Text=`More content {
o}`}end end,Bullets=function(k)k:BulletText{Rows={'Bullet point 1',
'Bullet point 2\nOn multiple lines'}}k:TreeNode():BulletText{Rows={
'Another bullet point'}}k:Bullet():Label{Text='Bullet point 3 (two calls)'}k:
Bullet():SmallButton()end,Text=function(k)local l=k:TreeNode{Title=
'Colorful Text'}l:Label{TextColor3=Color3.fromRGB(255,0,255),Text='Pink',NoTheme
=true}l:Label{TextColor3=Color3.fromRGB(255,255,0),Text='Yellow',NoTheme=true}l:
Label{TextColor3=Color3.fromRGB(59,59,59),Text='Disabled',NoTheme=true}local n=k
:TreeNode{Title='Word Wrapping'}n:Label{Text=
[[This text should automatically wrap on the edge of the window. The current implementation for text wrapping follows simple rules suitable for English and possibly other languages.]]
,TextWrapped=true}local o n:SliderInt{Label='Wrap width',Value=400,Minimum=20,
Maximum=600,Callback=function(p,q)if not o then return end o.Size=UDim2.
fromOffset(q,0)end}n:Label{Text='Test paragraph:'}o=n:Label{Text=
[[The lazy dog is a good dog. This paragraph should fit. Testing a 1 character word. The quick brown fox jumps over the lazy dog.]]
,TextWrapped=true,Border=true,BorderColor=Color3.fromRGB(255,255,0),
AutomaticSize=Enum.AutomaticSize.Y,Size=UDim2.fromOffset(400,0)}end,Images=
function(k)k:Label{TextWrapped=true,Text=
[[Below we are displaying the icons (which are the ones builtin to ReGui in this demo). Hover the texture for a zoomed view!]]
}k:Label{TextWrapped=true,Text=`There is a total of {aa:GetDictSize(aa.Icons)} icons in this demo!`
}local l,n,o=(k:List{Border=true})aa:SetItemTooltip(l,function(p)n=p:Label()o=p:
Image{Size=UDim2.fromOffset(50,50)}end)for p,q in aa.Icons do local r=l:Image{
Image=q,Size=UDim2.fromOffset(30,30)}aa:DetectHover(r,{MouseEnter=true,OnInput=
function()n.Text=p o.Image=q end})end end,Tabs=function(k)local l=k:TreeNode{
Title='Basic'}local n,o=l:TabSelector(),{'Avocado','Broccoli','Cucumber'}for p,q
in next,o do n:CreateTab{Name=q}:Label{Text=`This is the {q} tab!\nblah blah blah blah blah`
}end local p=k:TreeNode{Title='Advanced & Close Button'}local q,r=p:TabSelector(
),{'Artichoke','Beetroot','Celery','Daikon'}for s,t in next,r do local u=q:
CreateTab{Name=t,Closeable=true}u:Label{Text=`This is the {t} tab!\nblah blah blah blah blah`
}end p:Button{Text='Add tab',Callback=function()q:CreateTab{Closeable=true}:
Label{Text='I am an odd tab.'}end}end,['Plot widgets']=function(k)local l=k:
PlotHistogram{Points={0.6,0.1,1,0.5,0.92,0.1,0.2}}k:Button{Text=
'Generate new graph',Callback=function()local p={}for q=1,math.random(5,10)do
table.insert(p,math.random(1,10))end l:PlotGraph(p)end}end,[
'Multi-component Widgets']=function(k)k:Separator{Text='2-wide'}k:InputInt2{
Value={10,50},Minimum={0,0},Maximum={20,100},Callback=function(l,p)print('1:',p[
1],'2:',p[2])end}k:SliderInt2()k:SliderFloat2()k:DragInt2()k:DragFloat2()k:
Separator{Text='3-wide'}k:InputInt3()k:SliderInt3()k:SliderFloat3()k:DragInt3()k
:DragFloat3()k:Separator{Text='4-wide'}k:InputInt4()k:SliderInt4()k:
SliderFloat4()k:DragInt4()k:DragFloat4()end,['Progress Bars']=function(k)local l
=k:ProgressBar{Label='Loading...',Value=80}spawn(function()local p=0 while wait(
0.02)do p+=1 l:SetPercentage(p%100)end end)end,['Picker Widgets']=function(k)k:
Separator{Text='Color pickers'}k:DragColor3{Value=aa.Accent.Light}k:SliderColor3
{Value=aa.Accent.Red}k:InputColor3{Value=aa.Accent.Green}k:Separator{Text=
'CFrame pickers'}k:DragCFrame{Value=CFrame.new(1,1,1),Minimum=CFrame.new(0,0,0),
Maximum=CFrame.new(200,100,50)}k:SliderCFrame()k:InputCFrame()end,['Code editor'
]=function(k)k:CodeEditor{Text='print("Hello from ReGui\'s editor!")',Editable=
true}end,Console=function(k)local l=k:TreeNode{Title='Basic'}local p,q=l:Console
{ReadOnly=true,AutoScroll=true,MaxLines=50},k:TreeNode{Title=
'Advanced & RichText'}local r,s=q:Console{ReadOnly=true,AutoScroll=true,RichText
=true,MaxLines=50},k:TreeNode{Title='Editor'}s:Console{Value=
"print('Hello world!')",LineNumbers=true}coroutine.wrap(function()while wait()do
local t=DateTime.now():FormatLocalTime('h:mm:ss A','en-us')r:AppendText(`<font color="rgb(240, 40, 10)">[Random]</font>`
,math.random())p:AppendText(`[{t}] Hello world!`)end end)()end,Combo=function(k)
k:Combo{WidthFitPreview=true,Label='WidthFitPreview',Selected=1,Items={
'AAAAAAAAAAAA','BBBBBBBB','CCCCC','DDD'}}k:Separator{Text='One-liner variants'}k
:Combo{Label='Combo 1 (array)',Selected=1,Items={'AAAA','BBBB','CCCC','DDDD',
'EEEE','FFFF','GGGG','HHHH','IIIIIII','JJJJ','KKKKKKK'}}k:Combo{Label=
'Combo 1 (dict)',Selected='AAA',Items={AAA='Apple',BBB='Banana',CCC='Orange'},
Callback=print}k:Combo{Label='Combo 2 (function)',Selected=1,GetItems=function()
return{'aaa','bbb','ccc'}end}end,Indent=function(k)k:Label{Text=
'This is not indented'}local l=k:Indent{Offset=30}l:Label{Text=
'This is indented by 30 pixels'}local p=l:Indent{Offset=30}p:Label{Text=
'This is indented by 30 more pixels'}end,Viewport=function(k)local l=aa:
InsertPrefab'R15 Rig'local p=k:Viewport{Size=UDim2.new(1,0,0,200),Clone=true,
Model=l}local q=p.Model q:PivotTo(CFrame.new(0,-2.5,-5))local r=game:GetService
'RunService'r.RenderStepped:Connect(function(s)local t=CFrame.Angles(0,math.rad(
30*s),0)local u=q:GetPivot()*t q:PivotTo(u)end)end,['List layout']=function(k)
local l=k:List()for p=1,10 do l:Button{Text=`Resize the window! {p}`}end end,
Keybinds=function(k)local l=k:Checkbox{Value=true}k:Keybind{Label=
'Toggle checkbox',IgnoreGameProcessed=false,OnKeybindSet=function(p,q)warn(
'[OnKeybindSet] .Value ->',q)end,Callback=function(p,q)print(q)l:Toggle()end}k:
Keybind{Label='Keybind (w/ Q & Left-Click blacklist)',KeyBlacklist={Enum.
UserInputType.MouseButton1,Enum.KeyCode.Q}}k:Keybind{Label=
'Toggle UI visibility',Value=Enum.KeyCode.E,Callback=function()ag:
ToggleVisibility()end}end,Input=function(k)k:InputText{Label='One Line Text'}k:
InputTextMultiline{Label='Multiline Text'}k:InputInt{Label='Input int'}end,[
'Text Input']=function(k)local l=k:TreeNode{Title='Multiline'}l:
InputTextMultiline{Size=UDim2.new(1,0,0,117),Value=
'/*The Pentium FOOF bug, shorthand for FO OF C7 C8,\r\n    the hexadecimal encoding of one offending instruction,\r\n    more formally, the invalid operand with locked CMPXCHG8B\r\n    instruction bug, is a design flaw in the majority of\r\n    Intel Pentium, Pentium MMX, and Pentium OverDrive\r\n    processors (all in the P5 microarchitecture).#\r\n    */'
}end}for q,r in l do local s,t=k:TreeNode{Title=r},p[r]if t then task.spawn(t,s)
end end local q=d:CollapsingHeader{Title='Popups & child windows'}local r=q:
TreeNode{Title='Popups'}local s=r:Row()local t=s:Label{Text='<None>',LayoutOrder
=2}s:Button{Text='Select..',Callback=function(u)local v,w={'Bream','Haddock',
'Mackerel','Pollock','Tilefish'},r:PopupCanvas{RelativeTo=u,MaxSizeX=200}w:
Separator{Text='Aquarium'}for x,y in v do w:Selectable{Text=y,Callback=function(
z)t.Text=y w:ClosePopup()end}end end}local u=q:TreeNode{Title='Child windows'}
local v=u:Window{Size=UDim2.fromOffset(300,200),NoMove=true,NoClose=true,
NoCollapse=true,NoResize=true}v:Label{Text='Hello, world!'}v:Button{Text='Save'}
v:InputText{Label='string'}v:SliderFloat{Label='float',Minimum=0,Maximum=1}local
w=q:TreeNode{Title='Modals'}w:Label{Text=
[[Modal windows are like popups but the user cannot close them by clicking outside.]]
,TextWrapped=true}w:Button{Text='Delete..',Callback=function()local x=w:
PopupModal{Title='Delete?'}x:Label{Text=
[[All those beautiful files will be deleted.
This operation cannot be undone!]],
TextWrapped=true}x:Separator()x:Checkbox{Value=false,Label=
"Don't ask me next time"}local y=x:Row{Expanded=true}y:Button{Text='Okay',
Callback=function()x:ClosePopup()end}y:Button{Text='Cancel',Callback=function()x
:ClosePopup()end}end}w:Button{Text='Stacked modals..',Callback=function()local x
=w:PopupModal{Title='Stacked 1'}x:Label{Text=`Hello from Stacked The First\nUsing Theme["ModalWindowDimBg"] behind it.`
,TextWrapped=true}x:Combo{Items={'aaaa','bbbb','cccc','dddd','eeee'}}x:
DragColor3{Value=Color3.fromRGB(102,178,0)}x:Button{Text='Add another modal..',
Callback=function()local y=w:PopupModal{Title='Stacked 2'}y:Label{Text=
'Hello from Stacked The Second!',TextWrapped=true}y:DragColor3{Value=Color3.
fromRGB(102,178,0)}y:Button{Text='Close',Callback=function()y:ClosePopup()end}
end}x:Button{Text='Close',Callback=function()x:ClosePopup()end}end}local x=d:
CollapsingHeader{Title='Tables & Columns'}local y=x:TreeNode{Title='Basic'}local
z=y:Table()for A=1,3 do local B=z:Row()for C=1,3 do local D=B:Column()for E=1,4
do D:Label{Text=`Row {E} Column {C}`}end end end local A=x:TreeNode{Title=
'Borders, background'}local B=A:Table{RowBackground=true,Border=true,MaxColumns=
3}for C=1,5 do local D=B:NextRow()for E=1,3 do local F=D:NextColumn()F:Label{
Text=`Hello {E},{C}`}end end local C=x:TreeNode{Title='With headers'}local D,E=C
:Table{Border=true,RowBackground=true,MaxColumns=3},{'One','Two','Three'}for F=1
,7 do if F==1 then s=D:HeaderRow()else s=D:Row()end for G,H in E do if F==1 then
local I=s:Column()I:Label{Text=H}continue end local I=s:NextColumn()I:Label{Text
=`Hello {G},{F}`}end end end end function a.f()return{Dot=
'rbxasset://textures/whiteCircle.png',Arrow=
[[rbxasset://textures/DeveloperFramework/button_arrow_right.png]],Close=
'rbxasset://textures/AnimationEditor/icon_close.png',Checkmark=
'rbxasset://textures/AnimationEditor/icon_checkmark.png',Cat=
'rbxassetid://16211812161',Script='rbxassetid://11570895459',Settings=
'rbxassetid://9743465390',Info='rbxassetid://18754976792',Move=
'rbxassetid://6710235139',Roblox='rbxassetid://7414445494',Warning=
'rbxassetid://11745872910',Audio='rbxassetid://302250236',Shop=
'rbxassetid://6473525198',CharacterDance='rbxassetid://11932783331',Pants=
'rbxassetid://10098755331',Home='rbxassetid://4034483344',Robux=
'rbxassetid://5986143282',Badge='rbxassetid://16170504068',SpawnLocation=
'rbxassetid://6400507398',Sword='rbxassetid://7485051715',Clover=
'rbxassetid://11999300014',Star='rbxassetid://3057073083',Code=
'rbxassetid://11348555035',Paw='rbxassetid://13001190533',Shield=
'rbxassetid://7461510428',Shield2='rbxassetid://7169354142',File=
'rbxassetid://7276823330',Book='rbxassetid://16061686835',Location=
'rbxassetid://13549782519',Puzzle='rbxassetid://8898417863',Discord=
'rbxassetid://84828491431270',Premium='rbxassetid://6487178625',Friend=
'rbxassetid://10885655986',User='rbxassetid://18854794412',Duplicate=
'rbxassetid://11833749507',ChatBox='rbxassetid://15839118471',ChatBox2=
'rbxassetid://15839116089',Devices='rbxassetid://4458812712',Weight=
'rbxassetid://9855685269',Image='rbxassetid://123311808092347',Profile=
'rbxassetid://13585614795',Admin='rbxassetid://11656483170',PaintBrush=
'rbxassetid://12111879608',Speed='rbxassetid://12641434961',NoConnection=
'rbxassetid://9795340967',Connection='rbxassetid://119759670842477',Globe=
'rbxassetid://18870359747',Box='rbxassetid://140217940575618',Crown=
'rbxassetid://18826490498',Control='rbxassetid://18979524646',Send=
'rbxassetid://18940312887',FastForward='rbxassetid://112963221295680',Pause=
'rbxassetid://109949100737970',Reload='rbxassetid://11570018242',Joystick=
'rbxassetid://18749336354',Controller='rbxassetid://11894535915',Lock=
'rbxassetid://17783082088',Calculator='rbxassetid://85861816563977',Sun=
'rbxassetid://13492317832',Moon='rbxassetid://8498174594',Prohibited=
'rbxassetid://5248916036',Flag='rbxassetid://251346532',Website=
'rbxassetid://98455290625865',Telegram='rbxassetid://115860270107061',MusicNote=
'rbxassetid://18187351229',Music='rbxassetid://253830398',Headphones=
'rbxassetid://1311321471',Phone='rbxassetid://8411963035',Smartphone=
'rbxassetid://14040313879',Desktop='rbxassetid://3120635703',Desktop2=
'rbxassetid://4728059490',Laptop='rbxassetid://4728059725',Server=
'rbxassetid://9692125126',Wedge='rbxassetid://9086583059',Drill=
'rbxassetid://11959189471',Character='rbxassetid://13285102351'}end function a.g
()return{Light=Color3.fromRGB(50,150,250),Dark=Color3.fromRGB(30,66,115),
ExtraDark=Color3.fromRGB(28,39,53),White=Color3.fromRGB(240,240,240),Gray=Color3
.fromRGB(172,171,175),Black=Color3.fromRGB(15,19,24),Yellow=Color3.fromRGB(230,
180,0),Orange=Color3.fromRGB(230,150,0),Green=Color3.fromRGB(130,188,91),Red=
Color3.fromRGB(255,69,69),ImGui={Light=Color3.fromRGB(66,150,250),Dark=Color3.
fromRGB(41,74,122),Black=Color3.fromRGB(15,15,15),Gray=Color3.fromRGB(36,36,36)}
}end function a.h()local aa,ab=a.load'g',{}ab.DarkTheme={Values={
AnimationTweenInfo=TweenInfo.new(0.08),TextFont=Font.fromEnum(Enum.Font.
RobotoMono),TextSize=14,Text=aa.White,TextDisabled=aa.Gray,ErrorText=aa.Red,
FrameBg=aa.Dark,FrameBgTransparency=0.4,FrameBgActive=aa.Light,
FrameBgTransparencyActive=0.4,FrameRounding=UDim.new(0,0),SliderGrab=aa.Light,
ButtonsBg=aa.Light,CollapsingHeaderBg=aa.Light,CollapsingHeaderText=aa.White,
CheckMark=aa.Light,ResizeGrab=aa.Light,HeaderBg=aa.Gray,HeaderBgTransparency=0.7
,HistogramBar=aa.Yellow,ProgressBar=aa.Yellow,RegionBg=aa.Dark,
RegionBgTransparency=0.1,Separator=aa.Gray,SeparatorTransparency=0.5,
ConsoleLineNumbers=aa.White,LabelPaddingTop=UDim.new(0,0),LabelPaddingBottom=
UDim.new(0,0),MenuBar=aa.ExtraDark,MenuBarTransparency=0.1,PopupCanvas=aa.Black,
TabTextPaddingTop=UDim.new(0,3),TabTextPaddingBottom=UDim.new(0,8),TabText=aa.
Gray,TabBg=aa.Dark,TabTextActive=aa.White,TabBgActive=aa.Light,TabsBarBg=Color3.
fromRGB(36,36,36),TabsBarBgTransparency=1,TabPagePadding=UDim.new(0,8),
ModalWindowDimBg=Color3.fromRGB(230,230,230),ModalWindowDimTweenInfo=TweenInfo.
new(0.2),WindowBg=aa.Black,WindowBgTransparency=0.05,Border=aa.Gray,
BorderTransparency=0.8,BorderTransparencyActive=0.5,Title=aa.White,TitleAlign=
Enum.TextXAlignment.Left,TitleBarBg=aa.Black,TitleBarTransparency=0,TitleActive=
aa.White,TitleBarBgActive=aa.Dark,TitleBarTransparencyActive=0.05,
TitleBarBgCollapsed=Color3.fromRGB(0,0,0),TitleBarTransparencyCollapsed=0.6}}ab.
LightTheme={BaseTheme=ab.DarkTheme,Values={Text=aa.Black,TextFont=Font.fromEnum(
Enum.Font.Ubuntu),TextSize=14,FrameBg=aa.Gray,FrameBgTransparency=0.4,
FrameBgActive=aa.Light,FrameBgTransparencyActive=0.6,SliderGrab=aa.Light,
ButtonsBg=aa.Light,CollapsingHeaderText=aa.Black,Separator=aa.Black,
ConsoleLineNumbers=aa.Yellow,MenuBar=Color3.fromRGB(219,219,219),PopupCanvas=aa.
White,TabText=aa.Black,TabTextActive=aa.Black,WindowBg=aa.White,Border=aa.Gray,
ResizeGrab=aa.Gray,Title=aa.Black,TitleAlign=Enum.TextXAlignment.Center,
TitleBarBg=aa.Gray,TitleActive=aa.Black,TitleBarBgActive=Color3.fromRGB(186,186,
186),TitleBarBgCollapsed=aa.Gray}}ab.ImGui={BaseTheme=ab.DarkTheme,Values={
AnimationTweenInfo=TweenInfo.new(0),Text=Color3.fromRGB(255,255,255),FrameBg=aa.
ImGui.Dark,FrameBgTransparency=0.4,FrameBgActive=aa.ImGui.Light,
FrameBgTransparencyActive=0.5,FrameRounding=UDim.new(0,0),ButtonsBg=aa.ImGui.
Light,CollapsingHeaderBg=aa.ImGui.Light,CollapsingHeaderText=aa.White,CheckMark=
aa.ImGui.Light,ResizeGrab=aa.ImGui.Light,MenuBar=aa.ImGui.Gray,
MenuBarTransparency=0,PopupCanvas=aa.ImGui.Black,TabText=aa.Gray,TabBg=aa.ImGui.
Dark,TabTextActive=aa.White,TabBgActive=aa.ImGui.Light,WindowBg=aa.ImGui.Black,
WindowBgTransparency=0.05,Border=aa.Gray,BorderTransparency=0.7,
BorderTransparencyActive=0.4,Title=aa.White,TitleBarBg=aa.ImGui.Black,
TitleBarTransparency=0,TitleBarBgActive=aa.ImGui.Dark,TitleBarTransparencyActive
=0}}return ab end function a.i()local aa,ab=(a.load'b')aa:AddOnInit(function(ad)
ab=ad end)return{{Properties={'Center'},Callback=function(ad,ae,af)local ag=ae.
Position aa:SetProperties(ae,{Position=UDim2.new(af:find'X'and 0.5 or ag.X.Scale
,ag.X.Offset,af:find'Y'and 0.5 or ag.Y.Scale,ag.Y.Offset),AnchorPoint=Vector2.
new(af:find'X'and 0.5 or 0,af:find'Y'and 0.5 or 0)})end},{Properties={
'ElementStyle'},Callback=function(ad,ae,af)ab:ApplyStyle(ae,af)end},{Properties=
{'ColorTag'},Callback=function(ad,ae,af)local ag,ah=ad.Class,ad.WindowClass
local c=ag.NoAutoTheme if not ah then return end if c then return end ab:
UpdateColors{Object=ae,Tag=af,NoAnimation=true,Theme=ah.Theme}end},{Properties={
'Animation'},Callback=function(ad,ae,af)local ag=ad.Class.NoAnimation if ag then
return end ab:SetAnimation(ae,af)end},{Properties={'Image'},Callback=function(ad
,ae,af)local ag=ad.WindowClass ae.Image=aa:CheckAssetUrl(af)ab:DynamicImageTag(
ae,af,ag)end},{Properties={'Icon','IconSize','IconRotation','IconPadding'},
Callback=function(ad,ae,af)local ag=ae:FindFirstChild('Icon',true)if not ag then
ab:Warn('No icon for',ae)return end local ah=ad.Class aa:CheckConfig(ah,{Icon=''
,IconSize=UDim2.fromScale(1,1),IconRotation=0,IconPadding=UDim2.new(0,2)})local
c=ag.Parent:FindFirstChild'UIPadding'aa:SetPadding(c,ah.IconPadding)local d=ah.
Icon d=aa:CheckAssetUrl(d)local e=ad.WindowClass ab:DynamicImageTag(ag,d,e)aa:
SetProperties(ag,{Visible=ag~='',Image=aa:CheckAssetUrl(d),Size=ah.IconSize,
Rotation=ah.IconRotation})end},{Properties={'BorderThickness','Border',
'BorderColor'},Callback=function(ad,ae,af)local ag=ad.Class local ah=ag.Border==
true aa:CheckConfig(ag,{BorderTransparency=ad:GetThemeKey
'BorderTransparencyActive',BorderColor=ad:GetThemeKey'Border',BorderThickness=1,
BorderStrokeMode=Enum.ApplyStrokeMode.Border})local c=aa:GetChildOfClass(ae,
'UIStroke')aa:SetProperties(c,{Transparency=ag.BorderTransparency,Thickness=ag.
BorderThickness,Color=ag.BorderColor,ApplyStrokeMode=ag.BorderStrokeMode,Enabled
=ah})end},{Properties={'Ratio'},Callback=function(ad,ae,af)local ag=ad.Class aa:
CheckConfig(ag,{Ratio=1.3333333333333333,RatioAxis=Enum.DominantAxis.Height,
RatioAspectType=Enum.AspectType.ScaleWithParentSize})local ah,c,d,e=ag.Ratio,ag.
RatioAxis,ag.RatioAspectType,aa:GetChildOfClass(ae,'UIAspectRatioConstraint')aa:
SetProperties(e,{DominantAxis=c,AspectType=d,AspectRatio=ah})end},{Properties={
'FlexMode'},Callback=function(ad,ae,af)local ag=aa:GetChildOfClass(ae,
'UIFlexItem')ag.FlexMode=af end},{Properties={'CornerRadius'},Callback=function(
ad,ae,af)local ag=aa:GetChildOfClass(ae,'UICorner')ag.CornerRadius=af end},{
Properties={'Fill'},Callback=function(ad,ae,af)if af~=true then return end local
ag=ad.Class aa:CheckConfig(ag,{Size=UDim2.fromScale(1,1),UIFlexMode=Enum.
UIFlexMode.Fill,AutomaticSize=Enum.AutomaticSize.None})local ah=aa:
GetChildOfClass(ae,'UIFlexItem')ah.FlexMode=ag.UIFlexMode ae.Size=ag.Size ae.
AutomaticSize=ag.AutomaticSize end},{Properties={'Label'},Callback=function(ad,
ae,af)local ag,ah=ad.Class,ae:FindFirstChild'Label'if not ah then return end ah.
Text=tostring(af)function ag:SetLabel(c)ah.Text=c return self end end},{
Properties={'NoGradient'},WindowProperties={'NoGradients'},Callback=function(ad,
ae,af)local ag=ae:FindFirstChildOfClass'UIGradient'if not ag then return end ag.
Enabled=af end},{Properties={'UiPadding','PaddingBottom','PaddingTop',
'PaddingRight','PaddingTop'},Callback=function(ad,ae,af)af=af or 0 if typeof(af)
=='number'then af=UDim.new(0,af)end local ag=ad.Class local ah=ag.UiPadding if
ah then aa:CheckConfig(ag,{PaddingBottom=af,PaddingLeft=af,PaddingRight=af,
PaddingTop=af})end local c=aa:GetChildOfClass(ae,'UIPadding')aa:SetProperties(c,
{PaddingBottom=ag.PaddingBottom,PaddingLeft=ag.PaddingLeft,PaddingRight=ag.
PaddingRight,PaddingTop=ag.PaddingTop})end},{Properties={'Callback'},Callback=
function(ad,ae)local af=ad.Class function af:SetCallback(ag)self.Callback=ag
return self end function af:FireCallback(ag)self.Callback(ae)return self end end
},{Properties={'Value'},Callback=function(ad,ae)local af=ad.Class aa:
CheckConfig(af,{GetValue=function(ag)return af.Value end})end}}end function a.j(
)local aa={}aa.Coloring={MenuBar={BackgroundColor3='MenuBar',
BackgroundTransparency='MenuBarTransparency'},FrameRounding={CornerRadius=
'FrameRounding'},PopupCanvas={BackgroundColor3='PopupCanvas'},ModalWindowDim={
BackgroundColor3='ModalWindowDimBg'},Selectable='Button',MenuButton='Button',
Separator={BackgroundColor3='Separator',BackgroundTransparency=
'SeparatorTransparency'},Region={BackgroundColor3='RegionBg',
BackgroundTransparency='RegionBgTransparency'},Label={TextColor3='Text',FontFace
='TextFont',TextSize='TextSize'},ImageFollowsText={ImageColor3='Text'},
ConsoleLineNumbers={TextColor3='ConsoleLineNumbers',FontFace='TextFont',TextSize
='TextSize'},ConsoleText='Label',LabelDisabled={TextColor3='TextDisabled',
FontFace='TextFont',TextSize='TextSize'},Plot={BackgroundColor3='HistogramBar'},
Header={BackgroundColor3='HeaderBg',BackgroundTransparency=
'HeaderBgTransparency'},WindowTitle={TextXAlignment='TitleAlign',FontFace=
'TextFont',TextSize='TextSize'},TitleBar={BackgroundColor3='TitleBarBgActive'},
Window={BackgroundColor3='WindowBg',BackgroundTransparency=
'WindowBgTransparency'},TitleBarBgCollapsed={BackgroundColor3=
'TitleBarBgCollapsed',BackgroundTransparency='TitleBarTransparencyCollapsed'},
TitleBarBgActive={BackgroundColor3='TitleBarBgActive',BackgroundTransparency=
'TitleBarTransparencyActive'},TitleBarBg={BackgroundColor3='TitleBarBg',
BackgroundTransparency='TitleBarTransparency'},TabsBar={BackgroundColor3=
'TabsBarBg',BackgroundTransparency='TabsBarBgTransparency'},Border={Color=
'Border',Transparency='BorderTransparency'},ResizeGrab={TextColor3='ResizeGrab'}
,BorderActive={Transparency='BorderTransparencyActive'},Frame={BackgroundColor3=
'FrameBg',BackgroundTransparency='FrameBgTransparency',TextColor3='Text',
FontFace='TextFont',TextSize='TextSize'},FrameActive={BackgroundColor3=
'FrameBgActive',BackgroundTransparency='FrameBgTransparencyActive'},SliderGrab={
BackgroundColor3='SliderGrab'},Button={BackgroundColor3='ButtonsBg',TextColor3=
'Text',FontFace='TextFont',TextSize='TextSize'},CollapsingHeader={FontFace=
'TextFont',TextSize='TextSize',TextColor3='CollapsingHeaderText',
BackgroundColor3='CollapsingHeaderBg'},Checkbox={BackgroundColor3='FrameBg'},
CheckMark={ImageColor3='CheckMark',BackgroundColor3='CheckMark'},RadioButton={
BackgroundColor3='ButtonsBg',TextColor3='Text',FontFace='TextFont',TextSize=
'TextSize'}}aa.Styles={RadioButton={Animation='RadioButtons',CornerRadius=UDim.
new(1,0)},Button={Animation='Buttons'},CollapsingHeader={Animation='Buttons'},
TreeNode={Animation='TransparentButtons'},TransparentButton={Animation=
'TransparentButtons'}}aa.Animations={Invisible={Connections={MouseEnter={Visible
=true},MouseLeave={Visible=false}},Init='MouseLeave'},Buttons={Connections={
MouseEnter={BackgroundTransparency=0.3},MouseLeave={BackgroundTransparency=0.7}}
,Init='MouseLeave'},TextButtons={Connections={MouseEnter={TextTransparency=0.3},
MouseLeave={TextTransparency=0.7}},Init='MouseLeave'},TransparentButtons={
Connections={MouseEnter={BackgroundTransparency=0.3},MouseLeave={
BackgroundTransparency=1}},Init='MouseLeave'},RadioButtons={Connections={
MouseEnter={BackgroundTransparency=0.5},MouseLeave={BackgroundTransparency=1}},
Init='MouseLeave'},Inputs={Connections={MouseEnter={BackgroundTransparency=0},
MouseLeave={BackgroundTransparency=0.5}},Init='MouseLeave'},Plots={Connections={
MouseEnter={BackgroundTransparency=0.3},MouseLeave={BackgroundTransparency=0}},
Init='MouseLeave'},Border={Connections={Selected={Transparency=0,Thickness=1},
Deselected={Transparency=0.7,Thickness=1}},Init='Selected'}}return aa end end
local aa,ab,ad,ae,af={Version='1.4.6',Author='Depso',License='MIT',Repository=
'https://github.com/depthso/Dear-ReGui/',Debug=false,PrefabsId=71968920594655,
DefaultTitle='ReGui',ContainerName='ReGui',DoubleClickThreshold=0.3,
TooltipOffset=15,IniToSave={'Value'},ClassIgnored={'Visible','Text'},Container=
nil,Prefabs=nil,FocusedWindow=nil,HasTouchScreen=false,Services=nil,Elements={},
_FlagCache={},_ErrorCache={},Windows={},ActiveTooltips={},IniSettings={},
AnimationConnections={}},a.load'a',a.load'b',a.load'c',a.load'd'aa.DemoWindow=a.
load'e'aa.Services=ad.Services aa.Animation=ae aa.Icons=a.load'f'aa.Accent=a.
load'g'aa.ThemeConfigs=a.load'h'aa.ElementFlags=a.load'i'local ag=a.load'j'aa.
ElementColors=ag.Coloring aa.Animations=ag.Animations aa.Styles=ag.Styles ad:
CallOnInitConnections(aa)aa.DynamicImages={[aa.Icons.Arrow]='ImageFollowsText',[
aa.Icons.Close]='ImageFollowsText',[aa.Icons.Dot]='ImageFollowsText'}local ah=aa
.Services local c,d,e,f,g=ah.HttpService,ah.Players,ah.UserInputService,ah.
RunService,ah.InsertService local h=d.LocalPlayer aa.PlayerGui=h.PlayerGui aa.
Mouse=h:GetMouse()local i=function()end function GetAndRemove(j,k)local l=k[j]if
l then k[j]=nil end return l end function MoveTableItem(j,k,l)local p=table.
find(j,k)if not p then return end local q=table.remove(j,p)table.insert(j,l,q)
end function Merge(j,k)for l,p in next,k do j[l]=p end end function Copy(j,k)
local l=table.clone(j)if k then Merge(l,k)end return l end function aa:Warn(...)
warn('[ReGui]::',...)end function aa:Error(...)local j=aa:Concat({...},' ')local
k=`\n[ReGui]:: {j}`coroutine.wrap(error)(k)end function aa:IsDoubleClick(j)local
k=self.DoubleClickThreshold return j<k end function aa:StyleContainers()local j=
self.Container local k,l=j.Overlays,j.Windows self:SetProperties(l,{
OnTopOfCoreBlur=true})self:SetProperties(k,{OnTopOfCoreBlur=true})end function
aa:Init(j)j=j or{}if self.Initialised then return end Merge(self,j)Merge(self,{
Initialised=true,HasGamepad=self:IsConsoleDevice(),HasTouchScreen=self:
IsMobileDevice()})self:CheckConfig(self,{ContainerParent=function()return ad:
ResolveUIParent()end,Prefabs=function()return self:LoadPrefabs()end},true)self:
CheckConfig(self,{Container=function()return self:InsertPrefab('Container',{
Parent=self.ContainerParent,Name=self.ContainerName})end},true)local k,l,p=self.
Container,self.TooltipOffset,self.ActiveTooltips local q,r=k.Overlays,0 self:
StyleContainers()self.TooltipsContainer=self.Elements:Overlay{Parent=q}e.
InputBegan:Connect(function(s)if not self:IsMouseEvent(s,true)then return end
local t=tick()local u=t-r local v=self:IsDoubleClick(u)r=v and 0 or t self:
UpdateWindowFocuses()end)local s=function()local s,t=self.TooltipsContainer,#p>0
s.Visible=t if not t then return end local u,v=aa:GetMouseLocation()local w=q.
AbsolutePosition s.Position=UDim2.fromOffset(u-w.X+l,v-w.Y+l)end f:
BindToRenderStep('ReGui_InputUpdate',Enum.RenderPriority.Input.Value,s)end
function aa:CheckImportState()if self.Initialised then return end local j=self.
PrefabsId local k=ad:CheckAssetUrl(j)local l,p=pcall(function()return g:
LoadLocalAsset(k)end)self:Init{Prefabs=l and p or nil}end function aa:GetVersion
()return self.Version end function aa:IsMobileDevice()return e.TouchEnabled end
function aa:IsConsoleDevice()return e.GamepadEnabled end function aa:
GetScreenSize()return workspace.CurrentCamera.ViewportSize end function aa:
LoadPrefabs()local j,k=self.PlayerGui,'ReGui-Prefabs'local l=script:
WaitForChild(k,2)if l then return l end local p=j:WaitForChild(k,2)if p then
return p end return nil end function aa:CheckConfig(j,k,l,p)return ad:
CheckConfig(j,k,l,p)end function aa:CreateInstance(j,k,l)local p=Instance.new(j,
k)if l then local q=l.UsePropertiesList if not q then self:SetProperties(p,l)
else self:ApplyFlags{Object=p,Class=l}end end return p end function aa:
ConnectMouseEvent(j,k)local l,p,q,r,s=k.Callback,k.DoubleClick,k.
OnlyMouseHovering,0 if q then s=self:DetectHover(q)end j.Activated:Connect(
function(...)local t=tick()local u=t-r if s and not s.Hovering then return end
if p then if not aa:IsDoubleClick(u)then r=t return end r=0 end l(...)end)end
function aa:GetAnimation(j)return j and self.Animation or TweenInfo.new(0)end
function aa:DynamicImageTag(j,k,l)local p=self.DynamicImages local q=p[k]if not
q then return end if not l then return end l:TagElements{[j]=q}end function aa:
GetDictSize(j)local k=0 for l,p in j do k+=1 end return k end function aa:
RemoveAnimations(j)local k=self:GetAnimationData(j)local l=k.Connections for p,q
in next,l do q:Disconnect()end end function aa:GetAnimationData(j)local k=self.
AnimationConnections local l=k[j]if l then return l end local p={Connections={}}
k[j]=p return p end function aa:AddAnimationSignal(j,k)local l=self:
GetAnimationData(j)local p=l.Connections table.insert(p,k)end function aa:
SetAnimationsEnabled(j)self.NoAnimations=not j end function aa:SetAnimation(j,k,
l)l=l or j local p,q,r=self.Animations,self.HasTouchScreen,k if typeof(k)~=
'table'then r=p[k]end assert(r,`No animation data for Class {k}!`)self:
RemoveAnimations(l)local s,t,u,v,w=r.Init,r.Connections,r.Tweeninfo,r.
NoAnimation,self:GetAnimationData(j)local x,y,A,B,C,D=w.State,true,{},{}function
B:Reset(E)if not C then return end C(E)end function B:FireSignal(E,F)A[E](F)end
function B:Refresh(E)if not D then return end A[D](E)end function B:SetEnabled(E
)y=E end for E,F in next,t do local G,H=function(G)G=G==true D=E local H=self.
NoAnimations if H then return end if not y then return end w.State=E ae:Tween{
NoAnimation=G or v,Object=j,Tweeninfo=u,EndProperties=F}end,l[E]if not q then
local I=H:Connect(G)self:AddAnimationSignal(l,I)end A[E]=G if E==s then C=G end
end if x then B:FireSignal(x)else B:Reset(true)end return B end function aa:
ConnectDrag(j,k)self:CheckConfig(k,{DragStart=i,DragEnd=i,DragMovement=i,
OnDragStateChange=i})local l,p,q,r,s,t=k.DragStart,k.DragEnd,k.DragMovement,k.
OnDragStateChange,{StartAndEnd={Enum.UserInputType.MouseButton1,Enum.
UserInputType.Touch},Movement={Enum.UserInputType.MouseMovement,Enum.
UserInputType.Touch}},false local u,v,w=function(u,v)local w=u.UserInputType
return table.find(s[v],w)end,function(u)local v=u.Position return Vector2.new(v.
X,v.Y)end,function(u)self._DraggingDisabled=u t=u r(u)end local x=function(x)
local y,A,B=x.IsDragging,x.InputType,x.Callback return function(C)if x.
DraggingRequired~=t then return end if x.CheckDraggingDisabled and self.
_DraggingDisabled then return end if not u(C,A)then return end if x.UpdateState
then w(y)end local D=v(C)B(D)end end j.InputBegan:Connect(x{
CheckDraggingDisabled=true,DraggingRequired=false,UpdateState=true,IsDragging=
true,InputType='StartAndEnd',Callback=l})e.InputEnded:Connect(x{DraggingRequired
=true,UpdateState=true,IsDragging=false,InputType='StartAndEnd',Callback=p})e.
InputChanged:Connect(x{DraggingRequired=true,InputType='Movement',Callback=q})
end function aa:MakeDraggable(j)local k,l,p,q,r,s=j.Move,j.Grab,j.
OnDragStateChange,{}function q:SetEnabled(t)local u=j.StateChanged self.Enabled=
t if u then u(self)end end function q:CanDrag(t)return self.Enabled end local t,
u,v,w,x=function(t)if not q:CanDrag()then return end local u=j.DragBegin s=t u(s
)end,function(t)if not q:CanDrag()then return end local u,v=t-s,j.OnUpdate v(u)
end,function(t)r=k.Position end,function(t)local u=UDim2.new(r.X.Scale,r.X.
Offset+t.X,r.Y.Scale,r.Y.Offset+t.Y)j:SetPosition(u)end,function(t,u)ae:Tween{
Object=k,EndProperties={Position=u}}end self:CheckConfig(j,{Enabled=true,
OnUpdate=w,SetPosition=x,DragBegin=v})self:ConnectDrag(l,{DragStart=t,
DragMovement=u,OnDragStateChange=p})local y=j.Enabled q:SetEnabled(y)return q
end function aa:MakeResizable(j)aa:CheckConfig(j,{MinimumSize=Vector2.new(160,90
),MaximumSize=Vector2.new(math.huge,math.huge)})local k,l,p,q,r=j.MaximumSize,j.
MinimumSize,j.Resize,(j.OnUpdate)local s=aa:InsertPrefab('ResizeGrab',{Parent=p}
)local t,u,v=function(t)s.Visible=t.Enabled end,function(t)local u=r+t local v=
UDim2.fromOffset(math.clamp(u.X,l.X,k.X),math.clamp(u.Y,l.Y,k.Y))if q then q(v)
return end ae:Tween{Object=p,EndProperties={Size=v}}end,function(t)r=p.
AbsoluteSize end local w=self:MakeDraggable{Grab=s,OnUpdate=u,DragBegin=v,
StateChanged=t}w.Grab=s return w end function aa:IsMouseEvent(j,k)local l=j.
UserInputType.Name if k and l:find'Movement'then return end return l:find'Touch'
or l:find'Mouse'end function aa:DetectHover(j,k)local l=k or{}l.Hovering=false
local p,q,r,s,t,u=l.OnInput,l.OnHoverChange,l.Anykey,l.MouseMove,l.MouseEnter,l.
MouseOnly local v=function(v,w,x)if v and u then if not aa:IsMouseEvent(v,true)
then return end end if w~=nil then local y=l.Hovering l.Hovering=w if w~=y and q
then q(w)end end if not t and x then return end if p then local y=l.Hovering p(y
,v)return end end local w={j.MouseEnter:Connect(function()v(nil,true,true)end),j
.MouseLeave:Connect(function()v(nil,false,true)end)}if r or u then table.insert(
w,e.InputBegan:Connect(function(x)v(x)end))end if s then local x=j.MouseMoved:
Connect(function()v()end)table.insert(w,x)end function l:Disconnect()for x,y in
next,w do y:Disconnect()end end return l end function aa:StackWindows()local j,k
=self.Windows,20 for l,p in next,j do local q,r=p.WindowFrame,UDim2.fromOffset(k
*l,k*l)p:Center()q.Position+=r end end function aa:GetElementFlags(j)local k=
self._FlagCache return k[j]end function aa:UpdateColors(j)local k,l,p,q,r,s,t=j.
Object,j.Tag,j.NoAnimation,j.TagsList,j.Theme,j.Tweeninfo,self.ElementColors
local u,v,w=self:GetElementFlags(k),self.Debug,t[l]if typeof(w)=='string'then w=
t[w]end if typeof(l)=='table'then w=l elseif q then q[k]=l end if not w then
return end local x={}for y,A in next,w do local B=self:GetThemeKey(r,A)if u and
u[y]then continue end if not B then if v then self:Warn(`Color: '{A}' does not exist!`
)end continue end x[y]=B end ae:Tween{Tweeninfo=s,Object=k,NoAnimation=p,
EndProperties=x}end function aa:MultiUpdateColors(j)local k=j.Objects for l,p in
next,k do self:UpdateColors{TagsList=j.TagsList,Theme=j.Theme,NoAnimation=not j.
Animate,Tweeninfo=j.Tweeninfo,Object=l,Tag=p}end end function aa:ApplyStyle(j,k)
local l=self.Styles local p=l[k]if not p then return end self:ApplyFlags{Object=
j,Class=p}end function aa:ClassIgnores(j)local k=self.ClassIgnored local l=table
.find(k,j)return l and true or false end function aa:MergeMetatables(j,k)local l
,p=self.Debug,{}p.__index=function(q,r)local s,t=self:ClassIgnores(r),j[r]if t~=
nil and not s then return t end local u,v=pcall(function()local u=k[r]return
self:PatchSelf(k,u)end)return u and v or nil end p.__newindex=function(q,r,s)
local t,u=self:ClassIgnores(r),typeof(s)=='function'local v=j[r]~=nil or u if v
and not t then j[r]=s return end xpcall(function()k[r]=s end,function(w)if l
then self:Warn(`Newindex Error: {k}.{r} = {s}\n{w}`)end j[r]=s end)end return
setmetatable({},p)end function aa:Concat(j,k)local l=''for p,q in next,j do l..=
tostring(q)..(p~=#j and k or'')end return l end function aa:GetValueFromAliases(
j,k)for l,p in j do local q=k[p]if q~=nil then return q end end return nil end
function aa:RecursiveCall(j,k)for l,p in next,j:GetDescendants()do k(p)end end
function aa:ApplyFlags(j)local k,l,p,q=self.ElementFlags,j.Object,j.Class,j.
WindowClass function j:GetThemeKey(r)if q then return q:GetThemeKey(r)else
return aa:GetThemeKey(nil,r)end end self:SetProperties(l,p)for r,s in next,k do
local t,u,v,w=s.Properties,s.Callback,s.Recursive,s.WindowProperties local x=
self:GetValueFromAliases(t,p)if q and w and x==nil then x=self:
GetValueFromAliases(w,q)end if x==nil then continue end u(j,l,x)if v then self:
RecursiveCall(l,function(y)u(j,y,x)end)end end end function aa:SetProperties(j,k
)return ad:SetProperties(j,k)end function aa:InsertPrefab(j,k)local l=self.
Prefabs local p=l.Prefabs local q=p:WaitForChild(j)local r=q:Clone()if k then
local s=k.UsePropertiesList if not s then self:SetProperties(r,k)else self:
ApplyFlags{Object=r,Class=k}end end return r end function aa:GetContentSize(j,k)
local l,p,q,r=j:FindFirstChildOfClass'UIListLayout',j:FindFirstChildOfClass
'UIPadding',(j:FindFirstChildOfClass'UIStroke')if l and not k then r=l.
AbsoluteContentSize else r=j.AbsoluteSize end if p then local s,t,u,v=p.
PaddingTop.Offset,p.PaddingBottom.Offset,p.PaddingLeft.Offset,p.PaddingRight.
Offset r+=Vector2.new(u+v,s+t)end if q then local s=q.Thickness r+=Vector2.new(s
/2,s/2)end return r end function aa:PatchSelf(j,k,...)if typeof(k)~='function'
then return k,...end return function(l,...)return k(j,...)end end function aa:
MakeCanvas(j)local k,l,p,q,r,s,t=self.Elements,self.Debug,j.Element,j.
WindowClass,j.Class,j.OnChildChange,af:NewSignal()if s then t:Connect(s)end if
not q and l then self:Warn(`No WindowClass for {p}`)self:Warn(j)end local u=ad:
NewClass(k,{Class=r,RawObject=p,WindowClass=q or false,OnChildChange=t,Elements=
{}})local v={__index=function(v,w)local x=u[w]if x~=nil then return self:
PatchSelf(u,x)end local y=r[w]if y~=nil then return self:PatchSelf(r,y)end local
A=p[w]return self:PatchSelf(p,A)end,__newindex=function(v,w,x)local y=r[w]~=nil
if y then r[w]=x else p[w]=x end end}return setmetatable({},v)end function aa:
GetIniData(j)local k,l=self.IniToSave,{}for p,q in next,k do l[q]=j[q]end return
l end function aa:DumpIni(j)local k,l=self.IniSettings,{}for p,q in next,k do l[
p]=self:GetIniData(q)end if j then return c:JSONEncode(l)end return l end
function aa:LoadIniIntoElement(j,k)local l={Value=function(l)j:SetValue(l)end}
for p,q in next,k do local r=l[p]if r then r(q)continue end j[p]=q end end
function aa:LoadIni(j,k)local l=self.IniSettings assert(j,
'No Ini configuration was passed')if k then j=c:JSONDecode(j)end for p,q in next
,j do local r=l[p]self:LoadIniIntoElement(r,q)end end function aa:AddIniFlag(j,k
)local l=self.IniSettings l[j]=k end function aa:OnElementCreate(j)local k,l,p,q
,r=self._FlagCache,j.Flags,j.Object,j.Canvas,j.Class local s,t,u,v,w,x=q.
WindowClass,l.NoAutoTag,l.NoAutoFlags,l.ColorTag,l.NoStyle,l.IniFlag k[p]=l if x
then self:AddIniFlag(x,r)end if w then return end if not t and s then s:
TagElements{[p]=v}end if s then s:LoadStylesIntoElement(j)end if not u then self
:ApplyFlags{Object=p,Class=l,WindowClass=s}end end function aa:VisualError(j,k,l
)local p=self.Initialised and j.Error if not p then self:Error('Class:',l)return
end j:Error{Parent=k,Text=l}end function aa:WrapGeneration(j,k)local l,p,q=self.
_ErrorCache,k.Base,k.IgnoreDefaults return function(r,s,...)s=s or{}self:
CheckConfig(s,p)local t=s.CloneTable if t then s=table.clone(s)end local u,v,w=r
.RawObject,r.Elements,r.OnChildChange self:CheckConfig(s,{Parent=u,Name=s.
ColorTag},nil,q)if r==self then r=self.Elements end local x,y,A=pcall(j,r,s,...)
if x==false then if u then if l[u]then return end l[u]=y end self:VisualError(r,
u,y)self:Error('Class:',y)self:Error(debug.traceback())end if A==nil then A=y
end if w then w:Fire(y)end if A then if v then table.insert(v,A)end self:
OnElementCreate{Object=A,Flags=s,Class=y,Canvas=r}end return y,A end end
function aa:DefineElement(j,k)local l,p,q=self.Elements,self.ThemeConfigs,self.
ElementColors local r,s,t,u,v,w=p.DarkTheme,k.Base,k.Create,k.Export,k.ThemeTags
,k.ColorData self:CheckConfig(s,{ColorTag=j,ElementStyle=j})if v then Merge(r,v)
end if w then Merge(q,w)end local x=self:WrapGeneration(t,k)if u then self[j]=x
end l[j]=x return x end function aa:DefineGlobalFlag(j)local k=self.ElementFlags
table.insert(k,j)end function aa:DefineTheme(j,k)local l=self.ThemeConfigs self:
CheckConfig(k,{BaseTheme=l.DarkTheme})local p=GetAndRemove('BaseTheme',k)local q
={BaseTheme=p,Values=k}l[j]=q return q end function aa:GetMouseLocation()local j
=self.Mouse return j.X,j.Y end function aa:SetWindowFocusesEnabled(j)self.
WindowFocusesEnabled=j end function aa:UpdateWindowFocuses()local j,k=self.
Windows,self.WindowFocusesEnabled if not k then return end for l,p in j do local
q=p.HoverConnection if not q then continue end local r=q.Hovering if r then self
:SetFocusedWindow(p)return end end self:SetFocusedWindow(nil)end function aa:
WindowCanFocus(j)if j.NoSelect then return false end if j.Collapsed then return
false end if j._SelectDisabled then return false end return true end function aa
:GetFocusedWindow()return self.FocusedWindow end function aa:BringWindowToFront(
j)local k,l=self.Windows,j.NoBringToFrontOnFocus if l then return end
MoveTableItem(k,j,1)end function aa:SetFocusedWindow(j)local k,l=self:
GetFocusedWindow(),self.Windows if k==j then return end self.FocusedWindow=j if
j then local p=self:WindowCanFocus(j)if not p then return end self:
BringWindowToFront(j)end local p=#l for q,r in l do local s,t=self:
WindowCanFocus(r),r.WindowFrame if not s then continue end p-=1 if p then t.
ZIndex=p end local u=r==j r:SetFocused(u,p)end end function aa:SetItemTooltip(j,
k)local l,p,q=self.Elements,self.TooltipsContainer,self.ActiveTooltips local r,s
=p:Canvas{Visible=false,UiPadding=UDim.new()}task.spawn(k,r)aa:DetectHover(j,{
MouseMove=true,MouseEnter=true,OnHoverChange=function(t)if t then table.insert(q
,r)return end local u=table.find(q,r)table.remove(q,u)end,OnInput=function(t,u)s
.Visible=t end})end function aa:CheckFlags(j,k)for l,p in next,j do local q=k[l]
if not q then continue end p(q)end end function aa:GetThemeKey(j,k)local l=self.
ThemeConfigs if typeof(j)=='string'then j=l[j]end local p=l.DarkTheme j=j or p
local q,r=j.BaseTheme,j.Values local s=r[k]if s then return s end if q then
return self:GetThemeKey(q,k)end return end function aa:SelectionGroup(j)local k,
l,p=false,function(k,l)for p,q in next,j do if typeof(q)=='Instance'then
continue end if q==l then continue end k(q)end end local q=function(q)if k then
return end k=true local r=p p=q:GetValue()if not r then r=p end l(function(s)s:
SetValue(r)end,q)k=false end l(function(r)r.Callback=q end)end local j=aa.
Elements j.__index=j function j:GetObject()return self.RawObject end function j:
ApplyFlags(k,l)local p=self.WindowClass aa:ApplyFlags{WindowClass=p,Object=k,
Class=l}end function j:Remove()local k,l,p=self.OnChildChange,self:GetObject(),
self.Class local q=p.Remove if q then return q(p)end if k then k:Fire(p or self)
end if p then table.clear(p)end l:Destroy()table.clear(self)end function j:
GetChildElements()local k=self.Elements return k end function j:
ClearChildElements()local k=self:GetChildElements()for l,p in next,k do p:
Destroy()end end function j:TagElements(k)local l,p=self.WindowClass,aa.Debug if
not l then if p then aa:Warn('No WindowClass for TagElements:',k)end return end
l:TagElements(k)end function j:GetThemeKey(k)local l=self.WindowClass if l then
return l:GetThemeKey(k)end return aa:GetThemeKey(nil,k)end function j:
SetColorTags(k,l)local p=self.WindowClass if not p then return end local q,r=p.
TagsList,p.Theme aa:MultiUpdateColors{Animate=l,Theme=r,TagsList=q,Objects=k}end
function j:SetElementFocused(k,l)local p,q,r,s=self.WindowClass,aa.
HasTouchScreen,l.Focused,l.Animation aa:SetAnimationsEnabled(not r)if not r and
s then s:Refresh()end if not p then return end if not q then return end local t=
p.ContentCanvas t.Interactable=not r end aa:DefineElement('Dropdown',{Base={
ColorTag='PopupCanvas',Disabled=false,AutoClose=true,OnSelected=i},Create=
function(k,l)l.Parent=aa.Container.Overlays local p,q,r,s,t=l.Selected,l.Items,l
.OnSelected,k:PopupCanvas(l)local u,v,w=aa:MergeMetatables(l,s),{},function(u)r(
u)end function l:ClearEntries()for x,y in v do y:Remove()end end function l:
SetItems(x,y)local A=x[1]self:ClearEntries()for B,C in x do local D,E=A and C or
B,B==y or C==y local F=s:Selectable{Text=tostring(D),Selected=E,ZIndex=6,
Callback=function()return w(D)end}table.insert(v,F)end end if q then l:SetItems(
q,p)end return u,t end})aa:DefineElement('OverlayScroll',{Base={ElementClass=
'OverlayScroll',Spacing=UDim.new(0,4)},Create=function(k,l)local p,q,r=k.
WindowClass,l.ElementClass,l.Spacing local s=aa:InsertPrefab(q,l)local t,u=s:
FindFirstChild'ContentFrame'or s,s:FindFirstChild('UIListLayout',true)u.Padding=
r local v=aa:MergeMetatables(k,l)local w=aa:MakeCanvas{Element=t,WindowClass=p,
Class=v}function l:GetCanvasSize()return t.AbsoluteCanvasSize end return w,s end
})aa:DefineElement('Overlay',{Base={ElementClass='Overlay'},Create=j.
OverlayScroll})aa:DefineElement('Image',{Base={Image='',Callback=i},Create=
function(k,l)local p=aa:InsertPrefab('Image',l)p.Activated:Connect(function(...)
local q=l.Callback return q(p,...)end)return p end})aa:DefineElement(
'VideoPlayer',{Base={Video='',Callback=i},Create=function(k,l)local p=l.Video l.
Video=ad:CheckAssetUrl(p)local q=aa:InsertPrefab('VideoPlayer',l)return q end})
aa:DefineElement('Button',{Base={Text='Button',DoubleClick=false,Callback=i},
Create=function(k,l)local p=aa:InsertPrefab('Button',l)local q,r=aa:
MergeMetatables(l,p),l.DoubleClick function l:SetDisabled(s)self.Disabled=s end
aa:ConnectMouseEvent(p,{DoubleClick=r,Callback=function(...)if l.Disabled then
return end local s=l.Callback return s(q,...)end})return q,p end})aa:
DefineElement('Selectable',{Base={Text='Selectable',Callback=i,Selected=false,
Disabled=false,Size=UDim2.fromScale(1,0),AutomaticSize=Enum.AutomaticSize.Y,
TextXAlignment=Enum.TextXAlignment.Left,AnimationTags={Selected='Buttons',
Unselected='TransparentButtons'}},Create=function(k,l)local p,q,r,s=k.Class.
AfterClick,l.Selected,l.Disabled,aa:InsertPrefab('Button',l)local t=aa:
MergeMetatables(l,s)s.Activated:Connect(function(...)local u=l.Callback u(s,...)
if p then p(s,...)end end)function l:SetSelected(u)local v=self.AnimationTags
local w=u and v.Selected or v.Unselected self.Selected=u aa:SetAnimation(s,w)
return self end function l:SetDisabled(u)self.Disabled=u s.Interactable=not u
return self end l:SetSelected(q)l:SetDisabled(r)return t,s end})aa:
DefineElement('ImageButton',{Base={ElementStyle='Button',Callback=i},Create=j.
Image})aa:DefineElement('SmallButton',{Base={Text='Button',PaddingTop=UDim.new()
,PaddingBottom=UDim.new(),PaddingLeft=UDim.new(0,2),PaddingRight=UDim.new(0,2),
ColorTag='Button',ElementStyle='Button',Callback=i},Create=j.Button})aa:
DefineElement('Keybind',{Base={Label='Keybind',ColorTag='Frame',Value=nil,
DeleteKey=Enum.KeyCode.Backspace,IgnoreGameProcessed=true,Enabled=true,Disabled=
false,Callback=i,OnKeybindSet=i,OnBlacklistedKeybindSet=i,KeyBlacklist={},
UiPadding=UDim.new(),AutomaticSize=Enum.AutomaticSize.None,Size=UDim2.new(0.3,0,
0,19)},Create=function(k,l)local p,q,r,s,t=l.Value,l.Label,l.Disabled,l.
KeyBlacklist,aa:InsertPrefab('Button',l)local u,v,w,x=aa:MergeMetatables(l,t),k:
Label{Parent=t,Text=q,Position=UDim2.new(1,4,0.5),AnchorPoint=Vector2.new(0,0.5)
},function(u,...)return u(t,...)end,function(u)return table.find(s,u)end
function l:SetDisabled(y)self.Disabled=y t.Interactable=not y k:SetColorTags({[v
]=y and'LabelDisabled'or'Label'},true)return self end function l:SetValue(y)
local A,B=self.OnKeybindSet,self.DeleteKey if y==B then y=nil end self.Value=y t
.Text=y and y.Name or'Not set'w(A,y)return self end function l:WaitForNewKey()
self._WaitingForNewKey=true t.Text='...'t.Interactable=false end local y=
function(y)local A,B=y.KeyCode,y.UserInputType if B~=Enum.UserInputType.Keyboard
then return B end return A end local A=function(A)local B,C,D=l.
OnBlacklistedKeybindSet,l.Value,y(A)if not e.WindowFocused then return end if x(
D)then w(B,D)return end t.Interactable=true l._WaitingForNewKey=false if D.Name
=='Unknown'then return l:SetValue(C)end l:SetValue(D)return end local B=function
(B,C)local D,E,F,G,H,I=l.IgnoreGameProcessed,l.DeleteKey,l.Enabled,l.Value,l.
Callback,y(B)if l._WaitingForNewKey then A(B)return end if not F and t.
Interactable then return end if not D and C then return end if not G then return
end if I==E then return end if I.Name~=G.Name then return end w(H,I)end l:
SetValue(p)l:SetDisabled(r)l.Connection=e.InputBegan:Connect(B)t.Activated:
Connect(function()l:WaitForNewKey()end)aa:SetAnimation(t,'Inputs')return u,t end
})aa:DefineElement('ArrowButton',{Base={Direction='Left',ColorTag='Button',Icon=
aa.Icons.Arrow,Size=UDim2.fromOffset(21,21),IconSize=UDim2.fromScale(1,1),
IconPadding=UDim.new(0,4),Rotations={Left=180,Right=0}},Create=function(k,l)
local p,q=l.Direction,l.Rotations local r=q[p]l.IconRotation=r local s=aa:
InsertPrefab('ArrowButton',l)s.Activated:Connect(function(...)local t=l.Callback
return t(s,...)end)return s end})aa:DefineElement('Label',{Base={Font=
'Inconsolata'},ColorData={LabelPadding={PaddingTop='LabelPaddingTop',
PaddingBottom='LabelPaddingBottom'}},Create=function(k,l)local p,q,r,s,t,u,v,w=l
.Bold,l.Italic,l.Font,l.FontFace,Enum.FontWeight.Medium,Enum.FontWeight.Bold,
Enum.FontStyle.Normal,Enum.FontStyle.Italic local x,y,A=p and u or t,q and w or
v,p or q if not s and A then l.FontFace=Font.fromName(r,x,y)end local B=aa:
InsertPrefab('Label',l)local C=B:FindFirstChildOfClass'UIPadding'k:TagElements{[
C]='LabelPadding'}return B end})aa:DefineElement('Error',{Base={RichText=true,
TextWrapped=true},ColorData={Error={TextColor3='ErrorText',FontFace='TextFont'}}
,Create=function(k,l)local p=l.Text l.Text=`<b>\u{26d4} Error:</b> {p}`return k:
Label(l)end})aa:DefineElement('CodeEditor',{Base={Editable=true,Fill=true,Text=
''},Create=function(k,l)local p,q=k.WindowClass,ab.CodeFrame.new(l)local r=q.Gui
l.Parent=k:GetObject()aa:ApplyFlags{Object=r,WindowClass=p,Class=l}return q,r
end})local k={Engaged=false}k.__index=k function k:SetEngaged(l)local p=self.
WindowClass self.Engaged=l if p then p:SetCanvasInteractable(not l)end end
function k:IsHovering()local l=false self:Foreach(function(p)l=p.Popup:
IsMouseHovering()return l end)return l end function k:Foreach(l)local p=self.
Menus for q,r in next,p do local s=l(r)if s then break end end end function k:
SetFocusedMenu(l)self:Foreach(function(p)local q=p==l p:SetActiveState(q)end)end
function k:Close()self:SetEngaged(false)self:SetFocusedMenu(nil)end function k:
MenuItem(l)local p,q=self.Canvas,self.Menus local r=p:MenuButton(l)local s=p:
PopupCanvas{RelativeTo=r,MaxSizeX=210,Visible=false,AutoClose=false,AfterClick=
function()self:Close()end}local t={Popup=s,Button=r}aa:DetectHover(r,{MouseEnter
=true,OnInput=function()if not self.Engaged then return end self:SetFocusedMenu(
t)end})function t:SetActiveState(u)s:SetPopupVisible(u)r:SetSelected(u)end r.
Activated:Connect(function()self:SetFocusedMenu(t)self:SetEngaged(true)end)table
.insert(q,t)return s,t end aa:DefineElement('MenuBar',{Base={},Create=function(l
,p)local q,r=l.WindowClass,aa:InsertPrefab('MenuBar',p)local s=aa:MakeCanvas{
Element=r,WindowClass=q,Class=p}local t=ad:NewClass(k,{WindowClass=q,Canvas=s,
Object=r,Menus={}})Merge(t,p)aa:DetectHover(r,{MouseOnly=true,OnInput=function()
if not t.Engaged then return end if t:IsHovering()then return end t:Close()end})
local u=aa:MergeMetatables(t,s)return u,r end})aa:DefineElement('MenuButton',{
Base={Text='MenuButton',PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),
Size=UDim2.fromOffset(0,19),AutomaticSize=Enum.AutomaticSize.XY},Create=j.
Selectable})local l={ColorTags={BGSelected={[true]='SelectedTab',[false]=
'DeselectedTab'},LabelSelected={[true]='SelectedTabLabel',[false]=
'DeselectedTabLabel'}}}function l:SetButtonSelected(p,q)if p.IsSelected==q then
return end p.IsSelected=q local r,s,t=self.NoAnimation,self.WindowClass,self.
ColorTags local u,v,w,x,y=s.Theme,s.TagsList,t.BGSelected,t.LabelSelected,p.
TabButton local A=y.Button local B=A.Label aa:MultiUpdateColors{Animate=not r,
Theme=u,TagsList=v,Objects={[A]=w[q],[B]=x[q]}}end function l:CompareTabs(p,q)if
not p then return false end return p.MatchBy==q or p==q end function l:
ForEachTab(p,q)local r,s=typeof(p)=='string',self.Tabs for t,u in s do local v,w
=u.Name,false if r then w=v==p else w=self:CompareTabs(u,p)end q(u,w,t)end end
function l:RemoveTab(p)local q,r=self.OnTabRemove,self.Tabs self:ForEachTab(p,
function(s,t,u)if not t then return end local v,w=s.TabButton,s.OnClosure table.
remove(r,u)v:Destroy()q(self,s)w(s)end)return self end function l:CreateTab(p)p=
p or{}aa:CheckConfig(p,{Name='Tab',AutoSize='Y',Focused=false,OnClosure=i})local
q,r,s,t,u,v,w,x,y=self.AutoSelectNewTabs,self.WindowClass,self.ParentCanvas,self
.Tabs,self.TabsFrame,self.OnTabCreate,p.Focused,p.Name,p.Icon local A,B=w or#t<=
0 and q,aa:InsertPrefab('TabButton',p)B.Parent=u local C=B.Button local D,E=C:
FindFirstChildOfClass'UIPadding',C.Label E.Text=tostring(x)Merge(p,{TabButton=B}
)local F,G=function()self:SetActiveTab(p)end,{Closeable=function()local F=s:
RadioButton{Parent=C,Visible=not self.NoClose,Icon=aa.Icons.Close,IconSize=UDim2
.fromOffset(11,11),LayoutOrder=3,ZIndex=2,UsePropertiesList=true,Callback=
function()self:RemoveTab(p)end}local G=F.Icon aa:SetAnimation(G,{Connections={
MouseEnter={ImageTransparency=0},MouseLeave={ImageTransparency=1}},Init=
'MouseLeave'},B)end}C.Activated:Connect(F)aa:CheckFlags(G,p)table.insert(t,p)if
r then r:TagElements{[D]='TabPadding'}end aa:SetAnimation(C,'Buttons')self:
SetButtonSelected(p,A)s:ApplyFlags(B,p)local H=v(self,p)if A then self:
SetActiveTab(p)end return H or p end function l:SetActiveTab(p)local q,r,s,t,u=
self.Tabs,self.NoAnimation,self.ActiveTab,self.OnActiveTabChange,typeof(p)==
'string'self:ForEachTab(p,function(v,w,x)if w then MatchedTab=v end self:
SetButtonSelected(v,w)end)if not MatchedTab then return self end if self:
CompareTabs(MatchedTab,s)then return self end self.ActiveTab=MatchedTab t(self,
MatchedTab,s)return self end aa:DefineElement('TabBar',{Base={AutoSelectNewTabs=
true,OnActiveTabChange=i,OnTabCreate=i,OnTabRemove=i},ColorData={DeselectedTab={
BackgroundColor3='TabBg'},SelectedTab={BackgroundColor3='TabBgActive'},
DeselectedTabLabel={FontFace='TextFont',TextColor3='TabText'},SelectedTabLabel={
FontFace='TextFont',TextColor3='TabTextActive'},TabsBarSeparator={
BackgroundColor3='TabBgActive'},TabPadding={PaddingTop='TabTextPaddingTop',
PaddingBottom='TabTextPaddingBottom'},TabPagePadding={PaddingBottom=
'TabPagePadding',PaddingLeft='TabPagePadding',PaddingRight='TabPagePadding',
PaddingTop='TabPagePadding'}},Create=function(p,q)local r,s,t=p.WindowClass,aa:
InsertPrefab('TabsBar',q),ad:NewClass(l)local u,v=s.Separator,s.TabsFrame local
w=aa:MakeCanvas{Element=v,WindowClass=r,Class=t}Merge(t,q)Merge(t,{ParentCanvas=
p,Object=s,TabsFrame=v,WindowClass=r,Tabs={}})p:TagElements{[s]='TabsBar',[u]=
'TabsBarSeparator'}local x=aa:MergeMetatables(w,s)return x,s end})aa:
DefineElement('TabSelector',{Base={NoTabsBar=false,OnActiveTabChange=i,
OnTabCreate=i,OnTabRemove=i},Create=function(p,q)local r,s,t,u=p.WindowClass,q.
NoTabsBar,q.NoAnimation,aa:InsertPrefab('TabSelector',q)local v=u.Body local w=v
.PageTemplate w.Visible=false local x,y=function(x,y,...)local A,B,C=y.AutoSize,
y.Name,w:Clone()local D=ad:GetChildOfClass(C,'UIPadding')aa:SetProperties(C,{
Parent=v,Name=B,AutomaticSize=Enum.AutomaticSize[A],Size=UDim2.fromScale(A=='Y'
and 1 or 0,A=='X'and 1 or 0)})p:TagElements{[D]='TabPagePadding'}local E=aa:
MakeCanvas{Element=C,WindowClass=r,Class=y}q.OnTabCreate(x,y,...)Merge(y,{Page=C
,MatchBy=E})return E end,function(x,y,...)x:ForEachTab(y,function(A,B,C)local D=
A.Page D.Visible=B if not B then return end local E=p:GetThemeKey
'AnimationTweenInfo'ae:Tween{Object=D,Tweeninfo=E,NoAnimation=t,StartProperties=
{Position=UDim2.fromOffset(0,4)},EndProperties={Position=UDim2.fromOffset(0,0)}}
end)q.OnActiveTabChange(x,y,...)end local A=p:TabBar{Parent=u,Visible=not s,
OnTabCreate=x,OnActiveTabChange=y,OnTabRemove=function(A,B,...)B.Page:Remove()q.
OnTabRemove(...)end}local B=aa:MergeMetatables(A,u)return B,u end})aa:
DefineElement('RadioButton',{Base={Callback=i},Create=function(p,q)local r=aa:
InsertPrefab('RadioButton',q)r.Activated:Connect(function(...)local s=q.Callback
return s(r,...)end)return r end})aa:DefineElement('Checkbox',{Base={Label=
'Checkbox',IsRadio=false,Value=false,NoAutoTag=true,TickedImageSize=UDim2.
fromScale(1,1),UntickedImageSize=UDim2.fromScale(0,0),Callback=i,Disabled=false}
,Create=function(p,q)local r,s,t,u,v,w,x=q.IsRadio,q.Value,q.Label,q.
TickedImageSize,q.UntickedImageSize,q.Disabled,aa:InsertPrefab('CheckBox',q)
local y,A=aa:MergeMetatables(q,x),x.Tickbox local B=A.Tick B.Image=aa.Icons.
Checkmark local C,D,E,F=A:FindFirstChildOfClass'UIPadding',ad:GetChildOfClass(A,
'UICorner'),p:Label{Text=t,Parent=x,LayoutOrder=2},UDim.new(0,3)if r then B.
ImageTransparency=1 B.BackgroundTransparency=0 D.CornerRadius=UDim.new(1,0)else
F=UDim.new(0,2)end aa:SetProperties(C,{PaddingBottom=F,PaddingLeft=F,
PaddingRight=F,PaddingTop=F})local G,H=function(...)local G=q.Callback return G(
y,...)end,function(G,H)local I,J=p:GetThemeKey'AnimationTweenInfo',G and u or v
ae:Tween{Object=B,Tweeninfo=I,NoAnimation=H,EndProperties={Size=J}}end function
q:SetDisabled(I)self.Disabled=I x.Interactable=not I p:SetColorTags({[E]=I and
'LabelDisabled'or'Label'},true)return self end function q:SetValue(I,J)self.
Value=I H(I,J)G(I)return self end function q:SetTicked(...)aa:Warn
'Checkbox:SetTicked is deprecated, please use :SetValue'return self:SetValue(...
)end function q:Toggle()local I=not self.Value self.Value=I self:SetValue(I)
return self end local I=function()q:Toggle()end x.Activated:Connect(I)A.
Activated:Connect(I)q:SetValue(s,true)q:SetDisabled(w)aa:SetAnimation(A,
'Buttons',x)p:TagElements{[B]='CheckMark',[A]='Checkbox'}return y,x end})aa:
DefineElement('Radiobox',{Base={IsRadio=true,CornerRadius=UDim.new(1,0)},Create=
j.Checkbox})aa:DefineElement('PlotHistogram',{Base={ColorTag='Frame',Label=
'Histogram'},Create=function(p,q)local r,s,t=q.Label,q.Points,aa:InsertPrefab(
'Histogram',q)local u,v=aa:MergeMetatables(q,t),t.Canvas local w=v.PointTemplate
w.Visible=false p:Label{Text=r,Parent=t,Position=UDim2.new(1,4)}local x aa:
SetItemTooltip(t,function(y)x=y:Label()end)Merge(q,{_Plots={},_Cache={}})
function q:GetBaseValues()local y,A=self.Minimum,self.Maximum if y and A then
return y,A end local B=self._Plots for C,D in B do local E=D.Value if not y or E
<y then y=E end if not A or E>A then A=E end end return y,A end function q:
UpdateGraph()local y,A,B=self._Plots,self:GetBaseValues()if not A or not B then
return end local C=B-A for D,E in y do local F,G=E.Point,E.Value local H=(G-A)/C
H=math.clamp(H,0.05,1)F.Size=UDim2.fromScale(1,H)end return self end function q:
Plot(y)local A,B,C=self._Plots,{},w:Clone()local D=C.Bar aa:SetProperties(C,{
Parent=v,Visible=true})local E,F=aa:DetectHover(C,{MouseEnter=true,OnInput=
function()B:UpdateTooltip()end}),{Object=C,Point=D,Value=y}function B:
UpdateTooltip()local G=B:GetPointIndex()x.Text=`{G}:\t{F.Value}`end function B:
SetValue(G)F.Value=G q:UpdateGraph()if E.Hovering then self:UpdateTooltip()end
end function B:GetPointIndex()return table.find(A,F)end function B:Remove(G)
table.remove(A,self:GetPointIndex())C:Remove()q:UpdateGraph()end table.insert(A,
F)self:UpdateGraph()aa:SetAnimation(D,'Plots',C)p:TagElements{[D]='Plot'}return
B end function q:PlotGraph(y)local A=self._Cache local B=#A-#y if B>=1 then for
C=1,B do local D=table.remove(A,C)if D then D:Remove()end end end for C,D in y
do local E=A[C]if E then E:SetValue(D)continue end A[C]=self:Plot(D)end return
self end if s then q:PlotGraph(s)end return u,t end})aa:DefineElement('Viewport'
,{Base={IsRadio=true},Create=function(p,q)local r,s,t=q.Model,q.Camera,aa:
InsertPrefab('Viewport',q)local u,v=aa:MergeMetatables(q,t),t.Viewport local w=v
.WorldModel if not s then s=aa:CreateInstance('Camera',v)s.CFrame=CFrame.new(0,0
,0)end Merge(q,{Camera=s,WorldModel=w,Viewport=v})function q:SetCamera(x)self.
Camera=x v.CurrentCamera=x return self end function q:SetModel(x,y)local A=self.
Clone w:ClearAllChildren()if A then x=x:Clone()end if y then x:PivotTo(y)end x.
Parent=w self.Model=x return x end if r then q:SetModel(r)end q:SetCamera(s)
return u,t end})aa:DefineElement('InputText',{Base={Value='',Placeholder='',
Label='Input text',Callback=i,MultiLine=false,NoAutoTag=true,Disabled=false},
Create=function(p,q)local r,s,t,u,v,w=q.MultiLine,q.Placeholder,q.Label,q.
Disabled,q.Value,aa:InsertPrefab('InputBox',q)local x=w.Frame local y,A=x.Input,
aa:MergeMetatables(q,w)p:Label{Parent=w,Text=t,AutomaticSize=Enum.AutomaticSize.
X,Size=UDim2.fromOffset(0,19),Position=UDim2.new(1,4),LayoutOrder=2}aa:
SetProperties(y,{PlaceholderText=s,MultiLine=r})local B=function(...)local B=q.
Callback B(A,...)end function q:SetValue(C)y.Text=tostring(C)self.Value=C return
self end function q:SetDisabled(C)self.Disabled=C w.Interactable=not C p:
SetColorTags({[t]=C and'LabelDisabled'or'Label'},true)return self end function q
:Clear()y.Text=''return self end local C=function()local C=y.Text q.Value=C B(C)
end y:GetPropertyChangedSignal'Text':Connect(C)q:SetDisabled(u)q:SetValue(v)p:
TagElements{[y]='Frame'}return A,w end})aa:DefineElement('InputInt',{Base={Value
=0,Increment=1,Placeholder='',Label='Input Int',Callback=i},Create=function(p,q)
local r,s,t,u,v,w=q.Value,q.Placeholder,q.Label,q.Disabled,q.NoButtons,aa:
InsertPrefab('InputBox',q)local x,y=aa:MergeMetatables(q,w),w.Frame local A=y.
Input A.PlaceholderText=s local B,C,D,E=p:Button{Text='-',Parent=y,LayoutOrder=2
,Ratio=1,AutomaticSize=Enum.AutomaticSize.None,FlexMode=Enum.UIFlexMode.None,
Size=UDim2.fromScale(1,1),Visible=not v,Callback=function()q:Decrease()end},p:
Button{Text='+',Parent=y,LayoutOrder=3,Ratio=1,AutomaticSize=Enum.AutomaticSize.
None,FlexMode=Enum.UIFlexMode.None,Size=UDim2.fromScale(1,1),Visible=not v,
Callback=function()q:Increase()end},p:Label{Parent=w,Text=t,AutomaticSize=Enum.
AutomaticSize.X,Size=UDim2.fromOffset(0,19),Position=UDim2.new(1,4),LayoutOrder=
4},function(...)local B=q.Callback B(x,...)end function q:Increase()local F,G=
self.Value,self.Increment q:SetValue(F+G)end function q:Decrease()local F,G=self
.Value,self.Increment q:SetValue(F-G)end function q:SetDisabled(F)self.Disabled=
F w.Interactable=not F p:SetColorTags({[D]=F and'LabelDisabled'or'Label'},true)
return self end function q:SetValue(F)local G,H,I=self.Value,self.Minimum,self.
Maximum F=tonumber(F)if not F then F=G end if H and I then F=math.clamp(F,H,I)
end A.Text=F q.Value=F E(F)return self end local F=function()local F=A.Text q:
SetValue(F)end q:SetValue(r)q:SetDisabled(u)A.FocusLost:Connect(F)p:TagElements{
[C]='Button',[B]='Button',[A]='Frame'}return x,w end})aa:DefineElement(
'InputTextMultiline',{Base={Label='',Size=UDim2.new(1,0,0,39),Border=false,
ColorTag='Frame'},Create=function(p,q)return p:Console(q)end})aa:DefineElement(
'Console',{Base={Enabled=true,Value='',TextWrapped=false,Border=true,MaxLines=
300,LinesFormat='%s',Callback=i},Create=function(p,q)local r,s,t,u,v=q.ReadOnly,
q.LineNumbers,q.Value,q.Placeholder,aa:InsertPrefab('Console',q)local w,x,y=aa:
MergeMetatables(q,v),v.Source,v.Lines y.Visible=s function q:CountLines(A)local
B=x.Text:split'\n'local C=#B if C==1 and B[1]==''then return 0 end return C end
function q:UpdateLineNumbers()local A,B=self.LineNumbers,self.LinesFormat if not
A then return end local C=self:CountLines()y.Text=''for D=1,C do local E,F=B:
format(D),D~=C and'\n'or''y.Text..=`{E}{F}`end local D=y.AbsoluteSize.X x.Size=
UDim2.new(1,-D,0,0)return self end function q:CheckLineCount()local A=q.MaxLines
if not A then return end local B=x.Text local C=B:split'\n'if#C>A then local D=`{
C[1]}\\n`local E=B:sub(#D)self:SetValue(E)end return self end function q:
UpdateScroll()local A=v.AbsoluteCanvasSize v.CanvasPosition=Vector2.new(0,A.Y)
return self end function q:SetValue(A)if not self.Enabled then return end x.Text
=tostring(A)self:Update()return self end function q:GetValue()return x.Text end
function q:Clear()x.Text=''self:Update()return self end function q:AppendText(
...)local A,B=self:CountLines(true),aa:Concat({...},' ')if A==0 then return self
:SetValue(B)end local C=self:GetValue()local D=`{C}\n{B}`self:SetValue(D)return
self end function q:Update()local A=self.AutoScroll self:CheckLineCount()self:
UpdateLineNumbers()if A then self:UpdateScroll()end end local A=function()local
A=q:GetValue()q:Update()q:Callback(A)end q:SetValue(t)aa:SetProperties(x,q)aa:
SetProperties(x,{TextEditable=not r,Parent=v,PlaceholderText=u})p:TagElements{[x
]='ConsoleText',[y]='ConsoleLineNumbers'}x:GetPropertyChangedSignal'Text':
Connect(A)return w,v end})aa:DefineElement('Table',{Base={VerticalAlignment=Enum
.VerticalAlignment.Top,RowBackground=false,RowBgTransparency=0.87,Border=false,
Spacing=UDim.new(0,4)},Create=function(p,q)local r,s,t,u,v,w,x,y=p.WindowClass,q
.RowBgTransparency,q.RowBackground,q.Border,q.VerticalAlignment,q.MaxColumns,q.
Spacing,aa:InsertPrefab('Table',q)local A,B,C,D,E=aa:MergeMetatables(q,y),y.
RowTemp,0,{},u and t function q:Row(F)F=F or{}local G,H,I,J=F.IsHeader,0,{},B:
Clone()aa:SetProperties(J,{Name='Row',Visible=true,Parent=y})local K=J:
FindFirstChildOfClass'UIListLayout'aa:SetProperties(K,{VerticalAlignment=v,
Padding=not E and x or UDim.new(0,1)})if G then p:TagElements{[J]='Header'}else
C+=1 end if t and not G then local L=C%2~=1 and s or 1 J.BackgroundTransparency=
L end local L={}local M=aa:MergeMetatables(L,J)function L:Column(N)N=N or{}aa:
CheckConfig(N,{HorizontalAlign=Enum.HorizontalAlignment.Left,VerticalAlignment=
Enum.VerticalAlignment.Top})local O=J.ColumnTemp:Clone()local P=O:
FindFirstChildOfClass'UIListLayout'aa:SetProperties(P,N)local Q=O:
FindFirstChildOfClass'UIStroke'Q.Enabled=u local R=O:FindFirstChildOfClass
'UIPadding'if not E then R:Destroy()end aa:SetProperties(O,{Parent=J,Visible=
true,Name='Column'})return aa:MakeCanvas{Element=O,WindowClass=r,Class=M}end
function L:NextColumn()H+=1 local N=H%w+1 local O=I[N]if not O then O=self:
Column()I[N]=O end return O end table.insert(D,L)return M end function q:NextRow
()return self:Row()end function q:HeaderRow()return self:Row{IsHeader=true}end
function q:ClearRows()C=0 for F,G in next,y:GetChildren()do if not G:IsA'Frame'
then continue end if G==B then continue end G:Destroy()end return q end return A
,y end})aa:DefineElement('List',{Base={Spacing=4,HorizontalFlex=Enum.
UIFlexAlignment.None,VerticalFlex=Enum.UIFlexAlignment.None,HorizontalAlignment=
Enum.HorizontalAlignment.Left,VerticalAlignment=Enum.VerticalAlignment.Top,
FillDirection=Enum.FillDirection.Horizontal},Create=function(p,q)local r,s,t,u,v
,w,x,y=p.WindowClass,q.Spacing,q.HorizontalFlex,q.VerticalFlex,q.
HorizontalAlignment,q.VerticalAlignment,q.FillDirection,aa:InsertPrefab('List',q
)local A,B=aa:MergeMetatables(q,y),y.UIListLayout aa:SetProperties(B,{Padding=
UDim.new(0,s),HorizontalFlex=t,VerticalFlex=u,HorizontalAlignment=v,
VerticalAlignment=w,FillDirection=x})local C=aa:MakeCanvas{Element=y,WindowClass
=r,Class=A}return C,y end})aa:DefineElement('CollapsingHeader',{Base={Title=
'Collapsing Header',CollapseIcon=aa.Icons.Arrow,Collapsed=true,Offset=0,
NoAutoTag=true,NoAutoFlags=true,IconPadding=UDim.new(0,4),Activated=i},Create=
function(p,q)local r,s,t,u,v,w,x,y,A,B,C,D=q.Title,q.Collapsed,q.ElementStyle,q.
Offset,q.TitleBarProperties,q.OpenOnDoubleClick,q.OpenOnArrow,q.CollapseIcon,q.
IconPadding,q.Icon,q.NoArrow,aa:InsertPrefab('CollapsingHeader',q)local E=D.
TitleBar local F,G=E.Collapse,E.Icon p:ApplyFlags(G,{Image=B})local H,I=F.
CollapseIcon,F.UIPadding ad:SetPadding(I,A)p:ApplyFlags(H,{Image=y})local J,K,L=
p:Label{ColorTag='CollapsingHeader',Parent=E,LayoutOrder=2},p:Indent{Class=q,
Parent=D,Offset=u,LayoutOrder=2,Size=UDim2.fromScale(1,0),AutomaticSize=Enum.
AutomaticSize.None,PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,1)}local M=
function()local M=q.Activated M(K)end function q:Remove()D:Destroy()table.clear(
self)end function q:SetArrowVisible(N)H.Visible=N end function q:SetTitle(N)J.
Text=N end function q:SetVisible(N)D.Visible=N end function q:SetIcon(N)local O=
N and N~=''G.Visible=O if O then G.Image=ad:CheckAssetUrl(N)end end function q:
SetCollapsed(N)self.Collapsed=N local O,P,Q=aa:GetContentSize(L),K:GetThemeKey
'AnimationTweenInfo',UDim2.fromScale(1,0)local R=Q+UDim2.fromOffset(0,O.Y)ae:
HeaderCollapse{Tweeninfo=P,Collapsed=N,Toggle=H,Resize=L,Hide=L,ClosedSize=Q,
OpenSize=R}return self end local N=function()q:SetCollapsed(not q.Collapsed)end
if v then K:ApplyFlags(E,v)end if not x then aa:ConnectMouseEvent(E,{DoubleClick
=w,Callback=N})end H.Activated:Connect(N)E.Activated:Connect(M)q:SetCollapsed(s)
q:SetTitle(r)q:SetArrowVisible(not C)aa:ApplyStyle(E,t)K:TagElements{[E]=
'CollapsingHeader'}return K,D end})aa:DefineElement('TreeNode',{Base={Offset=21,
IconPadding=UDim.new(0,2),TitleBarProperties={Size=UDim2.new(1,0,0,13)}},Create=
j.CollapsingHeader})aa:DefineElement('Separator',{Base={NoAutoTag=true,
NoAutoTheme=true},Create=function(p,q)local r,s=q.Text,aa:InsertPrefab(
'SeparatorText',q)p:Label{Text=tostring(r),Visible=r~=nil,Parent=s,LayoutOrder=2
,Size=UDim2.new(),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4)}p:
TagElements{[s.Left]='Separator',[s.Right]='Separator'}return s end})aa:
DefineElement('Canvas',{Base={},Create=function(p,q)local r,s,t=p.WindowClass,q.
Scroll,q.Class or q local u=s and'ScrollingCanvas'or'Canvas'local v=aa:
InsertPrefab(u,q)local w=aa:MakeCanvas{Element=v,WindowClass=r,Class=t}return w,
v end})aa:DefineElement('ScrollingCanvas',{Base={Scroll=true},Create=j.Canvas})
aa:DefineElement('Region',{Base={Scroll=false,AutomaticSize=Enum.AutomaticSize.Y
},Create=function(p,q)local r,s=p.WindowClass,q.Scroll local t=s and
'ScrollingCanvas'or'Canvas'local u=aa:InsertPrefab(t,q)local v=aa:MakeCanvas{
Element=u,WindowClass=r,Class=q}return v,u end})aa:DefineElement('Group',{Base={
Scroll=false,AutomaticSize=Enum.AutomaticSize.Y},Create=function(p,q)local r,s=p
.WindowClass,aa:InsertPrefab('Group',q)local t=aa:MakeCanvas{Element=s,
WindowClass=r,Class=q}return t,s end})aa:DefineElement('Indent',{Base={Offset=15
,PaddingTop=UDim.new(),PaddingBottom=UDim.new(),PaddingRight=UDim.new()},Create=
function(p,q)local r=q.Offset q.PaddingLeft=UDim.new(0,r)return p:Canvas(q)end})
aa:DefineElement('BulletText',{Base={},Create=function(p,q)local r=q.Rows for s,
t in next,r do local u=p:Bullet(q)u:Label{Text=tostring(t),LayoutOrder=2,Size=
UDim2.fromOffset(0,14)}end end})aa:DefineElement('Bullet',{Base={Padding=3,Icon=
aa.Icons.Dot,IconSize=UDim2.fromOffset(5,5)},Create=function(p,q)local r,s,t=p.
WindowClass,q.Padding,aa:InsertPrefab('Bullet',q)local u,v=aa:MakeCanvas{Element
=t,WindowClass=r,Class=p},t.UIListLayout v.Padding=UDim.new(0,s)return u,t end})
aa:DefineElement('Row',{Base={Spacing=4,Expanded=false,HorizontalFlex=Enum.
UIFlexAlignment.None,VerticalFlex=Enum.UIFlexAlignment.None},Create=function(p,q
)local r,s,t,u,v,w=p.WindowClass,q.Spacing,q.Expanded,q.HorizontalFlex,q.
VerticalFlex,aa:InsertPrefab('Row',q)local x,y=aa:MergeMetatables(q,w),w:
FindFirstChildOfClass'UIListLayout'y.Padding=UDim.new(0,s)y.HorizontalFlex=u y.
VerticalFlex=v local A=aa:MakeCanvas{Element=w,WindowClass=r,Class=x}function q:
Expand()y.HorizontalFlex=Enum.UIFlexAlignment.Fill return self end if t then q:
Expand()end return A,w end})aa:DefineElement('SliderBase',{Base={Format='%.f',
Label='',Type='Slider',Callback=i,NoGrab=false,NoClick=false,Minimum=0,Maximum=
100,ColorTag='Frame',Disabled=false},Create=function(p,q)local r,s,t,u,v,w,x,y,A
=q.Value or q.Minimum,q.Format,q.Label,q.NoAnimation,q.NoGrab,q.NoClick,q.Type,q
.Disabled,aa:InsertPrefab'Slider'local B=A.Track local C,D,E=B.Grab,B.ValueText,
aa:MergeMetatables(q,A)local F,G,H=C.AbsoluteSize,aa:SetAnimation(A,'Inputs'),p:
Label{Parent=A,Text=t,Position=UDim2.new(1,4),Size=UDim2.fromScale(0,1)}Merge(q,
{Grab=C,Name=t})if x=='Slider'then B.Position=UDim2.fromOffset(F.X/2,0)B.Size=
UDim2.new(1,-F.X,1,0)end local I,J={Slider=function(I)return{AnchorPoint=Vector2
.new(0.5,0.5),Position=UDim2.fromScale(I,0.5)}end,Progress=function(I)return{
Size=UDim2.fromScale(I,1)}end,Snap=function(I,J,K,L)local M=(math.round(J)-K)/L
return{Size=UDim2.fromScale(1/L,1),Position=UDim2.fromScale(M,0.5)}end},function
(...)local I=q.Callback return I(E,...)end function q:SetDisabled(K)self.
Disabled=K A.Interactable=not K p:SetColorTags({[H]=K and'LabelDisabled'or
'Label'},true)return self end function q:SetValueText(K)D.Text=tostring(K)end
function q:SetValue(K,L)local M,N,O,P=p:GetThemeKey'AnimationTweenInfo',q.
Minimum,q.Maximum,K local Q=O-N if not L then P=(K-N)/Q else K=N+(Q*P)end P=math
.clamp(P,0,1)local R=I[x](P,K,N,O)ae:Tween{Object=C,Tweeninfo=M,NoAnimation=u,
EndProperties=R}self.Value=K self:SetValueText(s:format(K,O))J(K)return self end
local K,L=function(K)p:SetColorTags({[A]=K and'FrameActive'or'Frame'},true)p:
SetElementFocused(A,{Focused=K,Animation=G})end,function()if q.Disabled then
return end if q.ReadOnly then return end return true end local M=function(M)if
not L()then return end local N,O,P=B.AbsolutePosition.X,B.AbsoluteSize.X,M.X
local Q=P-N local R=math.clamp(Q/O,0,1)q:SetValue(R,true)end local N,O=function(
...)if not L()then return end K(true)if not w then M(...)end end,function()K(
false)end C.Visible=not v q:SetValue(r)q:SetDisabled(y)p:TagElements{[D]='Label'
,[C]='SliderGrab'}aa:ConnectDrag(B,{DragStart=N,DragMovement=M,DragEnd=O})return
E,A end})aa:DefineElement('SliderEnum',{Base={Items={},Label='Slider Enum',Type=
'Snap',Minimum=1,Maximum=10,Value=1,Callback=i,ColorTag='Frame'},Create=function
(p,q)local r,s=q.Callback,q.Value local t=function(t,u)u=math.round(u)local v=t.
Items t.Maximum=#v return v[u]end q.Callback=function(u,v)local w=t(u,v)u:
SetValueText(w)q.Value=w return r(u,w)end t(q,s)return p:SliderBase(q)end})aa:
DefineElement('SliderInt',{Base={Label='Slider Int',ColorTag='Frame'},Create=j.
SliderBase})aa:DefineElement('SliderFloat',{Base={Label='Slider Float',Format=
'%.3f',ColorTag='Frame'},Create=j.SliderBase})aa:DefineElement('DragInt',{Base={
Format='%.f',Label='Drag Int',Callback=i,Minimum=0,Maximum=100,ColorTag='Frame',
Disabled=false},Create=function(p,q)local r,s,t,u,v=q.Value or q.Minimum,q.
Format,q.Label,q.Disabled,aa:InsertPrefab'Slider'local w,x=aa:MergeMetatables(q,
v),v.Track local y,A=x.ValueText,x.Grab A.Visible=false local B,C,D,E,F,G=p:
Label{Parent=v,Text=t,Position=UDim2.new(1,7),Size=UDim2.fromScale(0,1)},0,0,aa:
SetAnimation(v,'Inputs'),function(...)local B=q.Callback return B(w,...)end
function q:SetValue(H,I)local J,K=self.Minimum,self.Maximum local L=K-J if not I
then C=((H-J)/L)*100 else H=J+(L*(C/100))end H=math.clamp(H,J,K)self.Value=H y.
Text=s:format(H,K)F(H)return self end function q:SetDisabled(H)self.Disabled=H p
:SetColorTags({[B]=H and'LabelDisabled'or'Label'},true)return self end local H,I
=function(H)p:SetColorTags({[v]=H and'FrameActive'or'Frame'},true)p:
SetElementFocused(v,{Focused=H,Animation=E})end,function()if q.Disabled then
return end if q.ReadOnly then return end return true end local J,K,L=function(J)
if not I()then return end H(true)G=J D=C end,function(J)if not I()then return
end local K=J.X-G.X local L=D+(K/2)C=math.clamp(L,0,100)q:SetValue(C,true)end,
function()H(false)end q:SetValue(r)q:SetDisabled(u)aa:ConnectDrag(x,{DragStart=J
,DragEnd=L,DragMovement=K})p:TagElements{[y]='Label'}return w,v end})aa:
DefineElement('DragFloat',{Base={Format='%.3f',Label='Drag Float',ColorTag=
'Frame'},Create=j.DragInt})aa:DefineElement('MultiElement',{Base={Callback=i,
Label='',Disabled=false,BaseInputConfig={},InputConfigs={},Value={},Minimum={},
Maximum={},MultiCallback=i},Create=function(p,q)local r,s,t,u,v,w,x,y=q.Label,q.
BaseInputConfig,q.InputConfigs,q.InputType,q.Disabled,q.Value,q.Minimum,q.
Maximum assert(u,'No input type provided for MultiElement')local A,B=p:Row{
Spacing=4}local C,D,E,F,G=A:Row{Size=UDim2.fromScale(0.65,0),Expanded=true},A:
Label{Size=UDim2.fromScale(0.35,0),LayoutOrder=2,Text=r},aa:MergeMetatables(q,A)
,{},false local H=function()local H={}for I,J in F do H[I]=J:GetValue()end q.
Value=H return H end local function I(...)local J=q.MultiCallback J(E,...)end
local J=function()if#F~=#t then return end if not G then return end local J=H()
I(J)end function q:SetDisabled(K)self.Disabled=K p:SetColorTags({[D]=K and
'LabelDisabled'or'Label'},true)for L,M in F do M:SetDisabled(K)end end function
q:SetValue(K)G=false for L,M in K do local N=F[L]assert(N,`No input object for index: {
L}`)N:SetValue(M)end G=true I(K)end s=Copy(s,{Size=UDim2.new(1,0,0,19),Label='',
Callback=J})for K,L in t do local M=Copy(s,L)aa:CheckConfig(M,{Minimum=x[K],
Maximum=y[K]})local N=C[u](C,M)table.insert(F,N)end Merge(q,{Row=C,Inputs=F})G=
true q:SetDisabled(v)q:SetValue(w)return E,B end})local p=function(p,q,r,s)aa:
DefineElement(p,{Base={Label=p,Callback=i,InputType=q,InputConfigs=table.create(
r,{}),BaseInputConfig={}},Create=function(t,u)local v=(u.BaseInputConfig)if s
then Merge(v,s)end aa:CheckConfig(v,{ReadOnly=u.ReadOnly,Format=u.Format})u.
MultiCallback=function(...)local w=u.Callback w(...)end return t:MultiElement(u)
end})end local q=function(q,r)aa:DefineElement(q,{Base={Label=q,Callback=i,Value
=aa.Accent.Light,Disabled=false,Minimum={0,0,0},Maximum={255,255,255,100},
BaseInputConfig={},InputConfigs={[1]={Format='R: %.f'},[2]={Format='G: %.f'},[3]
={Format='B: %.f'}}},Create=function(s,t)local u,v=t.Value,Copy(t,{Value={1,1,1}
,Callback=function(u,...)if t.ValueChanged then t:ValueChanged(...)end end})
local w,x=s[r](s,v)local y,A=aa:MergeMetatables(t,w),w.Row local B,C=A:Button{
BackgroundTransparency=0,Size=UDim2.fromOffset(19,19),UiPadding=0,Text='',Ratio=
1,ColorTag='',ElementStyle=''},function(...)local B=t.Callback return B(y,...)
end local D=function(D)B.BackgroundColor3=D C(D)end function t:ValueChanged(E)
local F,G,H=E[1],E[2],E[3]local I=Color3.fromRGB(F,G,H)self.Value=I D(I)end
function t:SetValue(E)self.Value=E D(E)w:SetValue{math.round(E.R*255),math.
round(E.G*255),math.round(E.B*255)}end t:SetValue(u)return y,x end})end local r=
function(r,s)aa:DefineElement(r,{Base={Label=r,Callback=i,Disabled=false,Value=
CFrame.new(10,10,10),Minimum=CFrame.new(0,0,0),Maximum=CFrame.new(100,100,100),
BaseInputConfig={},InputConfigs={[1]={Format='X: %.f'},[2]={Format='Y: %.f'},[3]
={Format='Z: %.f'}}},Create=function(t,u)local v,w,x=u.Value,u.Maximum,u.Minimum
local y=Copy(u,{Maximum={w.X,w.Y,w.Z},Minimum={x.X,x.Y,x.Z},Value={v.X,v.Y,v.Z},
Callback=function(y,...)if u.ValueChanged then u:ValueChanged(...)end end})local
A,B=t[s](t,y)local C=aa:MergeMetatables(u,A)local D=function(...)local D=u.
Callback return D(C,...)end function u:ValueChanged(E)local F,G,H=E[1],E[2],E[3]
local I=CFrame.new(F,G,H)self.Value=I D(I)end function u:SetValue(E)self.Value=E
A:SetValue{math.round(E.X),math.round(E.Y),math.round(E.Z)}end u:SetValue(v)
return C,B end})end aa:DefineElement('SliderProgress',{Base={Label=
'Slider Progress',Type='Progress',ColorTag='Frame'},Create=j.SliderBase})aa:
DefineElement('ProgressBar',{Base={Label='Progress Bar',Type='Progress',ReadOnly
=true,MinValue=0,MaxValue=100,Format='% i%%',Interactable=false,ColorTag='Frame'
},Create=function(s,t)function t:SetPercentage(u)t:SetValue(u)end local u,v=s:
SliderBase(t)local w=u.Grab s:TagElements{[w]={BackgroundColor3='ProgressBar'}}
return u,v end})aa:DefineElement('Combo',{Base={Value='',Placeholder='',Callback
=i,Items={},Disabled=false,WidthFitPreview=false,Label='Combo'},Create=function(
s,t)local u,v,w,x,y,A,B=t.Placeholder,t.NoAnimation,t.Selected,t.Label,t.
Disabled,t.WidthFitPreview,aa:InsertPrefab('Combo',t)local C,D,E=aa:
MergeMetatables(t,B),(B.Combo)local F,G,H=s:Label{Text=tostring(u),Parent=D,Name
='ValueText'},s:ArrowButton{Parent=D,Interactable=false,Size=UDim2.fromOffset(19
,19),LayoutOrder=2},s:Label{Text=x,Parent=B,LayoutOrder=2}if A then aa:
SetProperties(B,{AutomaticSize=Enum.AutomaticSize.XY,Size=UDim2.new(0,0,0,0)})aa
:SetProperties(D,{AutomaticSize=Enum.AutomaticSize.XY,Size=UDim2.fromScale(0,1)}
)end local I,J=function(I,...)t:SetOpen(false)return t.Callback(C,I,...)end,
function(I,J)local K=s:GetThemeKey'AnimationTweenInfo'B.Interactable=not I ae:
HeaderCollapseToggle{Tweeninfo=K,NoAnimation=J,Collapsed=not I,Toggle=G.Icon}end
local function K()local L,M=t.GetItems,t.Items if L then return L()end return M
end function t:SetValueText(L)F.Text=tostring(L)end function t:ClosePopup()if
not E then return end E:ClosePopup(true)end function t:SetDisabled(L)self.
Disabled=L B.Interactable=not L s:SetColorTags({[H]=L and'LabelDisabled'or
'Label'},true)return self end function t:SetValue(L)local M=K()local N=M[L]local
O=N or L self.Selected=L self.Value=O self:ClosePopup()if typeof(L)=='number'
then self:SetValueText(O)else self:SetValueText(L)end I(L,O)return self end
function t:SetOpen(L)local M=self.Selected self.Open=L J(L,v)if not L then self:
ClosePopup()return end E=s:Dropdown{RelativeTo=D,Items=K(),Selected=M,OnSelected
=function(...)t:SetValue(...)end,OnClosed=function()self:SetOpen(false)end}
return self end local L=function()local L=t.Open t:SetOpen(not L)end D.Activated
:Connect(L)J(false,true)t:SetDisabled(y)if w then t:SetValue(w)end aa:
SetAnimation(D,'Inputs')s:TagElements{[D]='Frame'}return C,B end})local s={
TileBarConfig={Close={Image=aa.Icons.Close,IconPadding=UDim.new(0,3)},Collapse={
Image=aa.Icons.Arrow,IconPadding=UDim.new(0,3)}},CloseCallback=i,Collapsible=
true,Open=true,Focused=false}function s:Tween(t)aa:CheckConfig(t,{Tweeninfo=self
:GetThemeKey'AnimationTweenInfo'})return ae:Tween(t)end function s:TagElements(t
)local u,v=self.TagsList,self.Theme aa:MultiUpdateColors{Theme=v,TagsList=u,
Objects=t}end function s:MakeTitleBarCanvas()local t=self.TitleBar local u=aa:
MakeCanvas{WindowClass=self,Element=t}self.TitleBarCanvas=u return u end
function s:AddDefaultTitleButtons()local t=self.TileBarConfig local u,v,w=t.
Collapse,t.Close,self.TitleBarCanvas if not w then w=self:MakeTitleBarCanvas()
end aa:CheckConfig(self,{Toggle=w:RadioButton{Icon=u.Image,IconPadding=u.
IconPadding,LayoutOrder=1,Ratio=1,Size=UDim2.new(0,0),Callback=function()self:
ToggleCollapsed()end},CloseButton=w:RadioButton{Icon=v.Image,IconPadding=v.
IconPadding,LayoutOrder=3,Ratio=1,Size=UDim2.new(0,0),Callback=function()self:
SetVisible(false)end},TitleLabel=w:Label{ColorTag='Title',LayoutOrder=2,Size=
UDim2.new(1,0),Active=false,Fill=true,ClipsDescendants=true,AutomaticSize=Enum.
AutomaticSize.XY}})self:TagElements{[self.TitleLabel]='WindowTitle'}end function
s:Close()local t=self.CloseCallback if t then local u=t(self)if u==false then
return end end self:Remove()end function s:SetVisible(t)local u,v=self.
WindowFrame,self.NoFocusOnAppearing self.Visible=t u.Visible=t if t and not v
then aa:SetFocusedWindow(self)end return self end function s:ToggleVisibility(t)
local u=self.Visible self:SetVisible(not u)end function s:GetWindowSize()return
self.WindowFrame.AbsoluteSize end function s:GetTitleBarSizeY()local t=self.
TitleBar return t.Visible and t.AbsoluteSize.Y or 0 end function s:SetTitle(t)
self.TitleLabel.Text=tostring(t)return self end function s:SetPosition(t)self.
WindowFrame.Position=t return self end function s:SetSize(t,u)local v=self.
WindowFrame if typeof(t)=='Vector2'then t=UDim2.fromOffset(t.X,t.Y)end v.Size=t
self.Size=t return self end function s:SetCanvasInteractable(t)local u=self.Body
u.Interactable=t end function s:Center()local t=self:GetWindowSize()/2 local u=
UDim2.new(0.5,-t.X,0.5,-t.Y)self:SetPosition(u)return self end function s:
LoadStylesIntoElement(t)local u,v,w=t.Flags,t.Object,t.Canvas local x={
FrameRounding=function()if u.CornerRadius then return end if not w then return
end local x=v:FindFirstChild('FrameRounding',true)if not x then return end w:
TagElements{[x]='FrameRounding'}end}for y,A in x do local B=self:GetThemeKey(y)
if B==nil then continue end task.spawn(A,B)end end function s:SetTheme(t)local u
,v,w=aa.ThemeConfigs,self.TagsList,self.WindowState t=t or self.Theme assert(u[t
],`{t} is not a valid theme!`)self.Theme=t aa:MultiUpdateColors{Animate=false,
Theme=t,Objects=v}self:SetFocusedColors(w)return self end function s:
SetFocusedColors(t)local u,v,w,x,y=self.WindowFrame,self.TitleBar,self.Theme,
self.TitleLabel,self:GetThemeKey'AnimationTweenInfo'local A=u:
FindFirstChildOfClass'UIStroke'local B={Focused={[A]='BorderActive',[v]=
'TitleBarBgActive',[x]={TextColor3='TitleActive'}},UnFocused={[A]='Border',[v]=
'TitleBarBg',[x]={TextColor3='Title'}},Collapsed={[A]='Border',[v]=
'TitleBarBgCollapsed',[x]={TextColor3='Title'}}}aa:MultiUpdateColors{Tweeninfo=y
,Animate=true,Objects=B[t],Theme=w}end function s:SetFocused(t)t=t==nil and true
or t local u,v=self.Collapsed,self.WindowState if t then aa:SetFocusedWindow(
self)end local w=u and'Collapsed'or t and'Focused'or'UnFocused'if w==v then
return end self.Focused=t self.WindowState=w self:SetFocusedColors(w)end
function s:GetThemeKey(t)return aa:GetThemeKey(self.Theme,t)end function s:
SetCollapsible(t)self.Collapsible=t return self end function s:ToggleCollapsed(t
)local u,v=self.Collapsed,self.Collapsible if not t and not v then return self
end self:SetCollapsed(not u)return self end function s:SetCollapsed(t,u)local v,
w,x,y,A,B,C,D,E=self.WindowFrame,self.Body,self.Toggle,self.ResizeGrab,self.Size
,self.AutoSize,self:GetThemeKey'AnimationTweenInfo',self:GetWindowSize(),self:
GetTitleBarSizeY()local F,G=x.Icon,UDim2.fromOffset(D.X,E)self.Collapsed=t self:
SetCollapsible(false)self:SetFocused(not t)ae:HeaderCollapse{Tweeninfo=C,
NoAnimation=u,Collapsed=t,Toggle=F,Resize=v,NoAutomaticSize=not B,Hide=w,
ClosedSize=G,OpenSize=A,Completed=function()self:SetCollapsible(true)end}self:
Tween{Object=y,NoAnimation=u,EndProperties={TextTransparency=t and 1 or 0.6,
Interactable=not t}}return self end function s:UpdateConfig(t)local u={
NoTitleBar=function(u)local v=self.TitleBar v.Visible=not u end,NoClose=function
(u)local v=self.CloseButton v.Visible=not u end,NoCollapse=function(u)local v=
self.Toggle v.Visible=not u end,NoTabsBar=function(u)local v=self.
WindowTabSelector if not v then return end local w=v.TabsBar w.Visible=not u end
,NoScrollBar=function(u)local v,w,x,y=u and 0 or 9,self.NoScroll,self.
WindowTabSelector,self.ContentCanvas if x then x.Body.ScrollBarThickness=v end
if not w then y.ScrollBarThickness=v end end,NoScrolling=function(u)local v,w,x=
self.NoScroll,self.WindowTabSelector,self.ContentCanvas if w then w.Body.
ScrollingEnabled=not u end if not v then x.ScrollingEnabled=not u end end,NoMove
=function(u)local v=self.DragConnection v:SetEnabled(not u)end,NoResize=function
(u)local v=self.ResizeConnection v:SetEnabled(not u)end,NoBackground=function(u)
local v,w=self:GetThemeKey'WindowBgTransparency',self.CanvasFrame w.
BackgroundTransparency=u and 1 or v end}Merge(self,t)for v,w in t do local x=u[v
]if x then x(w)end end return self end function s:Remove()local t,u,v=self.
WindowFrame,self.WindowClass,aa.Windows local w=table.find(v,u)if w then table.
remove(v,w)end t:Destroy()end function s:MenuBar(t,...)local u,v=self.
ContentCanvas,self.ContentFrame t=t or{}Merge(t,{Parent=v,Layout=-1})return u:
MenuBar(t,...)end aa:DefineElement('Window',{Export=true,Base={Theme='DarkTheme'
,NoSelect=false,NoTabs=true,NoScroll=false,Collapsed=false,Visible=true,AutoSize
=false,MinimumSize=Vector2.new(160,90),OpenOnDoubleClick=true,NoAutoTheme=true,
NoWindowRegistor=false,NoBringToFrontOnFocus=false,IsDragging=false},Create=
function(t,u)aa:CheckImportState()local v,w=aa.Windows,aa.Container.Windows aa:
CheckConfig(u,{Parent=w,Title=aa.DefaultTitle})local x,y,A,B,C,D,E,F,G,H,I=u.
NoDefaultTitleBarButtons,u.Collapsed,u.MinimumSize,u.Title,u.NoTabs,u.NoScroll,u
.Theme,u.AutomaticSize,u.NoWindowRegistor,u.AutoSelectNewTabs,u.Parent~=w local
J={Scroll=not D,Fill=not F and true or nil,UiPadding=UDim.new(0,C and 8 or 0),
AutoSelectNewTabs=H}if F then Merge(J,{AutomaticSize=F,Size=UDim2.new(1,0)})end
local K=aa:InsertPrefab('Window',u)local L=K.Content local M,N=L.TitleBar,ad:
NewClass(s)local O,P,Q,R=(aa:MakeCanvas{Element=L,WindowClass=N,Class=N})local S
,T=O:Canvas(Copy(J,{Parent=L,CornerRadius=UDim.new(0,0)}))local U=aa:
MakeResizable{MinimumSize=A,Resize=K,OnUpdate=function(U)N:SetSize(U,true)end}
Merge(N,u)Merge(N,{WindowFrame=K,ContentFrame=L,CanvasFrame=T,ResizeGrab=U.Grab,
TitleBar=M,Elements=j,TagsList={},_SelectDisabled=I,ResizeConnection=U,
HoverConnection=aa:DetectHover(L),DragConnection=aa:MakeDraggable{Grab=L,Move=K,
SetPosition=function(V,W)local X=P:GetThemeKey'AnimationTweenInfo'ae:Tween{
Tweeninfo=X,Object=V.Move,EndProperties={Position=W}}end,OnDragStateChange=
function(V)N.IsDragging=V T.Interactable=not V if V then aa:SetFocusedWindow(R)
end aa:SetWindowFocusesEnabled(not V)end}})if C then P,Q=S,T else P,Q=S:
TabSelector(J)N.WindowTabSelector=P end R=aa:MergeMetatables(N,P)Merge(N,{
ContentCanvas=P,WindowClass=R,Body=Q})aa:ConnectMouseEvent(L,{DoubleClick=true,
OnlyMouseHovering=M,Callback=function(...)if not N.OpenOnDoubleClick then return
end if N.NoCollapse then return end N:ToggleCollapsed()end})if not x then N:
AddDefaultTitleButtons()end N:SetTitle(B)N:SetCollapsed(y,true)N:SetTheme(E)N:
UpdateConfig(u)N:SetFocused()if not G then table.insert(v,R)end local V=U.Grab
aa:SetAnimation(V,'TextButtons')aa:SetFocusedWindow(R)R:TagElements{[V]=
'ResizeGrab',[M]='TitleBar',[T]='Window'}return R,K end})aa:DefineElement(
'TabsWindow',{Export=true,Base={NoTabs=false,AutoSelectNewTabs=true},Create=
function(t,u)return t:Window(u)end})aa:DefineElement('PopupCanvas',{Base={
AutoClose=false,Scroll=false,Visible=true,Spacing=UDim.new(0,1),AutomaticSize=
Enum.AutomaticSize.XY,MaxSizeY=150,MinSizeX=100,MaxSizeX=math.huge,OnClosed=i},
Create=function(t,u)local v,w,x,y,A,B,C=u.RelativeTo,u.MaxSizeY,u.MinSizeX,u.
MaxSizeX,u.Visible,u.AutoClose,u.NoAnimation u.Parent=aa.Container.Overlays
local D,E=t:OverlayScroll(u)local F=E.UIStroke local G,H,I,J,K,L,M=F.Thickness,E
.Parent.AbsolutePosition,(aa:DetectHover(E,{MouseOnly=true,OnInput=function(G,H)
if G then return end if not E.Visible then return end u:OnFocusLost()end}))
function u:FetchScales()local N=D:GetCanvasSize()J=v.AbsolutePosition K=v.
AbsoluteSize L=math.clamp(N.Y,K.Y,w)M=math.clamp(K.X,x,y)end function u:
UpdatePosition()E.Position=UDim2.fromOffset(J.X-H.X+G,J.Y-H.Y+K.Y)end function u
:GetScale(N)local O,P=UDim2.fromOffset(M,L),UDim2.fromOffset(M,0)return N and O
or P end function u:IsMouseHovering()return I.Hovering end function u:
OnFocusLost()local N=self.OnClosed self:SetPopupVisible(false)N(self)if B then
self:ClosePopup()end end function u:ClosePopup(N)self:SetPopupVisible(false,C,N)
I:Disconnect()E:Remove()end function u:SetPopupVisible(N,O)if E.Visible==N then
return end v.Interactable=not N self:UpdateScales(N,C,O)self.Visible=N end
function u:UpdateScales(N,O,P)local Q=D:GetThemeKey'AnimationTweenInfo'N=N==nil
and E.Visible or N u:FetchScales()u:UpdatePosition()local R=ae:Tween{Tweeninfo=Q
,Object=E,NoAnimation=O,EndProperties={Size=u:GetScale(N),Visible=N}}if R and P
then R.Completed:Wait()end end u:UpdateScales(false,true)u:SetPopupVisible(A)D.
OnChildChange:Connect(u.UpdateScales)return D,E end})aa:DefineElement(
'PopupModal',{Export=true,Base={NoAnimation=false,NoCollapse=true,NoClose=true,
NoResize=true,NoSelect=true,NoAutoFlags=true,NoWindowRegistor=true,NoScroll=true
},Create=function(t,u)local v,w,x=t.WindowClass,(u.NoAnimation)u.Parent=aa.
Container.Overlays if v then x=v:GetThemeKey'ModalWindowDimTweenInfo'u.Theme=v.
Theme end local y=aa:InsertPrefab('ModalEffect',u)local A=t:Window(Copy(u,{
NoAutoFlags=false,Parent=y,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.
fromScale(0.5,0.5),Size=UDim2.fromOffset(372,38),AutomaticSize=Enum.
AutomaticSize.Y}))function u:ClosePopup()ae:Tween{Object=y,Tweeninfo=x,
NoAnimation=w,EndProperties={BackgroundTransparency=1},Completed=function()y:
Destroy()end}A:Close()end ae:Tween{Object=y,Tweeninfo=x,NoAnimation=w,
StartProperties={BackgroundTransparency=1},EndProperties={BackgroundTransparency
=0.8}}t:TagElements{[y]='ModalWindowDim'}local B=aa:MergeMetatables(u,A)return B
,y end})p('InputInt2','InputInt',2,{NoButtons=true})p('InputInt3','InputInt',3,{
NoButtons=true})p('InputInt4','InputInt',4,{NoButtons=true})p('SliderInt2',
'SliderInt',2)p('SliderInt3','SliderInt',3)p('SliderInt4','SliderInt',4)p(
'SliderFloat2','SliderFloat',2)p('SliderFloat3','SliderFloat',3)p('SliderFloat4'
,'SliderFloat',4)p('DragInt2','DragInt',2)p('DragInt3','DragInt',3)p('DragInt4',
'DragInt',4)p('DragFloat2','DragFloat',2)p('DragFloat3','DragFloat',3)p(
'DragFloat4','DragFloat',4)q('InputColor3','InputInt3')q('SliderColor3',
'SliderInt3')q('DragColor3','DragInt3')r('InputCFrame','InputInt3')r(
'SliderCFrame','SliderInt3')r('DragCFrame','DragInt3')return aa
