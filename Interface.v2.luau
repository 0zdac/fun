--[[
		Sealz Interface
	Author: 4lpaca
	Licene: MIT
	Version: 2.5
]]

local Sealz = {};

Sealz.cloneref = cloneref or function(f) return f end;
Sealz.get_service = function(name: string): ServiceProvider
	return game:GetService(name) or game:FindFirstChild(name);
end;


--- Signal+ Library ---
export type Signal<Parameters...> = {
	Connect: typeof(
		-- Connects a function.
		function(signal: Signal<Parameters...>, callback: (Parameters...) -> ()): Connection end
	),
	Once: typeof(
		-- Connects a function, then auto-disconnects after the first call.
		function(signal: Signal<Parameters...>, callback: (Parameters...) -> ()): Connection end
	),
	Wait: typeof(
		-- Yields the calling thread until the next fire.
		function(signal: Signal<Parameters...>): Parameters... end
	),

	Fire: typeof(
		-- Runs all connected functions and resumes all waiting threads.
		function(signal: Signal<Parameters...>, ...: Parameters...) end
	),

	Get: typeof(
		-- Runs all connected functions and resumes all waiting threads.
		function(signal: Signal<Parameters...>): any end
	),

	DisconnectAll: typeof(
		-- Erases all connections.
		-- <strong>Much faster than calling <code>Disconnect</code> on each.</strong>
		function(signal: Signal<Parameters...>) end
	),
	Destroy: typeof(
		-- Erases all connections and methods.
		-- <strong>To fully erase, also remove all references to the signal.</strong>
		function(signal: Signal<Parameters...>) end
	)
}
export type Connection = {
	Signal: Signal,
	Connected: boolean,
	Disconnect: typeof(
		-- Removes the connection from the signal.
		-- <strong>The connection's data remains.</strong>
		function(connection: Connection) end
	)
}
type CreateSignal = typeof(
	-- Creates a new signal.
	function(): Signal end
)

local SignalLibrary = function() -- Signal+
	-- Spawn function.
	local spawnThread = task.spawn;

	-- Setup reusable callback threads.
	local threads = {}

	local function reusableThreadCall(callback, thread, ...)
		callback(...)
		table.insert(threads, thread)
	end
	local function reusableThread()
		while true do
			reusableThreadCall(coroutine.yield())
		end
	end

	-- Connection methods.
	local function disconnect(connection)
		-- Verify connection.
		if not connection.Connected then return end

		-- Remove connection.
		connection.Connected = nil

		local signal = connection.Signal
		local previous = connection.Previous
		local next = connection.Next
		if previous then
			previous.Next = next
		else
			signal.Tail = next
		end
		if next then
			next.Previous = previous
		else
			signal.Head = previous
		end
	end

	-- Signal methods.
	local Signal = {}
	Signal.__index = Signal

	Signal.Connect = function(signal, callback)
		-- Linked list head.
		local head = signal.Head

		-- Create connection.
		local connection = {
			Signal = signal,
			Previous = head,

			Callback = callback,

			Connected = true,
			Disconnect = disconnect
		}

		-- Add connection.
		if head then
			head.Next = connection
		else
			signal.Tail = connection
		end
		signal.Head = connection

		-- Return connection.
		return connection
	end
	Signal.Once = function(signal, callback)
		-- Linked list head.
		local head = signal.Head

		-- Create connection.
		local connection
		connection = {
			Signal = signal,
			Previous = head,

			Callback = function(...)
				-- Verify connection.
				if not connection.Connected then return end

				-- Remove connection.
				connection.Connected = false

				local previous = connection.Previous
				local next = connection.Next
				if previous then
					previous.Next = next
				else
					signal.Tail = next
				end
				if next then
					next.Previous = previous
				else
					signal.Head = previous
				end

				-- Fire callback.
				callback(...)
			end,

			Connected = true,
			Disconnect = disconnect
		}

		-- Add connection.
		if head then
			head.Next = connection
		else
			signal.Tail = connection
		end
		signal.Head = connection

		-- Return connection.
		return connection
	end
	Signal.Wait = function(signal)
		-- Save this thread to resume later.
		local thread = coroutine.running()

		-- Linked list head.
		local head = signal.Head

		-- Create connection.
		local connection
		connection = {
			Previous = head,

			Callback = function(...)
				-- Remove connection.
				connection.Connected = false

				local previous = connection.Previous
				local next = connection.Next
				if previous then
					previous.Next = next
				else
					signal.Tail = next
				end
				if next then
					next.Previous = previous
				else
					signal.Head = previous
				end

				-- Resume the thread.
				if coroutine.status(thread) == "suspended" then -- To avoid creating new threads.
					task.spawn(thread, ...)
				end
			end
		}

		-- Add connection.
		if head then
			head.Next = connection
		else
			signal.Tail = connection
		end
		signal.Head = connection

		-- Yield until the next fire, then return the arguments on resume.
		return coroutine.yield()
	end

	Signal.Fire = function(signal, ...)
		signal.Default = ...;

		local connection = signal.Tail -- Start from the tail (back) of the list.
		while connection do
			-- Find or create a thread, then run the callback in it.
			local length = #threads
			if length == 0 then
				local thread = coroutine.create(reusableThread)
				coroutine.resume(thread) -- Initialize.
				spawnThread(thread, connection.Callback, thread, ...)
			else
				local thread = threads[length]
				threads[length] = nil -- Remove from free threads list.
				spawnThread(thread, connection.Callback, thread, ...)
			end
			-- Traverse.
			connection = connection.Next
		end
	end;

	Signal.Get = function(signal)
		return signal.Default
	end;

	Signal.DisconnectAll = function(signal)
		-- Remove all connections.
		local connection = signal.Tail
		while connection do
			-- Save next connection.
			local nextConnection = connection.Next
			-- Remove data and pointers.
			connection.Connected = nil
			connection.Next = nil
			connection.Previous = nil
			-- Traverse.
			connection = nextConnection
		end
		-- Remove signal's references.
		signal.Tail = nil
		signal.Head = nil
	end
	Signal.Destroy = function(signal)
		-- Remove all connections.
		local connection = signal.Tail
		while connection do
			-- Save next connection.
			local nextConnection = connection.Next
			-- Remove data and pointers.
			connection.Connected = nil
			connection.Next = nil
			connection.Previous = nil
			-- Traverse.
			connection = nextConnection
		end
		-- Remove signal's references.
		signal.Tail = nil
		signal.Head = nil

		-- Unlink signal methods.
		setmetatable(signal, nil)
	end

	-- Signal creation function.
	return function(default)
		local meta = setmetatable({}, Signal) -- New blank table linked to the signal methods.

		meta.Default = default;

		return meta;
	end :: CreateSignal
end;

getgenv = getgenv or getfenv;

if game:GetService('RunService'):IsStudio() then
	local BaseWorkspace = Instance.new('Folder',game:GetService("ReplicatedFirst"));

	BaseWorkspace.Name = tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)));

	local __get_path_c = function(path)
		return (string.find(path,'/',1,true) and string.split(path,'/')) or (string.find(path,'\\',1,true) and string.split(path,'\\')) or {path};
	end;

	local __get_path = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			block = block[v];
		end;

		return block;
	end;

	getgenv().readfile = function(path)
		local path : StringValue = __get_path(path);

		return path.Value;
	end;

	getgenv().isfile = function(path)
		local success , message = pcall(function()
			return __get_path(path);
		end);

		if success and not message:IsA("Folder") then
			return true;
		end;

		return false;
	end;

	getgenv().isfolder = function(path)
		local success , message = pcall(function()
			return __get_path(path);
		end);

		if success and message:IsA("Folder") then
			return true;
		end;

		return false;
	end;

	getgenv().writefile = function(path,content)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('StringValue',block);

				c.Name = tostring(v);
				c.Value = content;
			else
				if item:IsA('StringValue') and tostring(item) == v then
					item.Name = tostring(v);
					item.Value = content;
				end;

				block = item;
			end;
		end;
	end;

	getgenv().listfiles = function(path)
		local fold = __get_path(path);
		local pa = {};

		for i,v in next , fold:GetChildren() do
			if v:IsA('StringValue') then
				table.insert(pa,path..'/'..tostring(v));
			end;
		end;

		return pa;
	end;

	getgenv().makefolder = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if not item then
				local c = Instance.new('Folder',block);

				c.Name = tostring(v);
			else
				block = item;
			end;
		end;
	end;

	getgenv().delfile = function(path)
		local main = __get_path_c(path);

		local block = BaseWorkspace;

		for i,v in next , main do
			local item = block:FindFirstChild(v);
			if item and item:IsA('StringValue') then
				item:Destroy();
			else
				block = item;
			end;
		end;
	end;
end;

local Players: Players = Sealz.get_service("Players");
local LocalPlayer: Player = Players.LocalPlayer;
local Mouse: Mouse = LocalPlayer:GetMouse();
local UserInputService: UserInputService = Sealz.get_service("UserInputService");
local Lighting: Lighting = Sealz.get_service("Lighting");
local RunService: RunService = Sealz.get_service("RunService");
local HttpService: HttpService = Sealz.get_service("HttpService");
local TweenService: TweenService = Sealz.get_service("TweenService");
local TextService: TextService = Sealz.get_service("TextService");
local CoreGui: PlayerGui = (gethui and gethui()) or Sealz.get_service("CoreGui") or LocalPlayer.PlayerGui;
local ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s) return s; end;
local CurrentCamera: Camera = Sealz.cloneref(workspace.CurrentCamera);
local CreateSignal = SignalLibrary();
local Twnf = TweenInfo.new(0.45,Enum.EasingStyle.Quint);

local SealzUI = Instance.new("ScreenGui")

SealzUI.Name = "SealzUI";
SealzUI.Parent = CoreGui;
SealzUI.ResetOnSpawn = false;
SealzUI.ZIndexBehavior = Enum.ZIndexBehavior.Global;
SealzUI.IgnoreGuiInset = true;
--rbxasset://fonts/families/RobotoMono.json , rbxasset://fonts/families/Inconsolata.json
Sealz.MediumFont = Font.new("rbxasset://fonts/families/RobotoMono.json",Enum.FontWeight.Medium,Enum.FontStyle.Normal);
Sealz.BoldFont = Font.new("rbxasset://fonts/families/RobotoMono.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal);
Sealz.IconFont = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json",Enum.FontWeight.Bold,Enum.FontStyle.Normal);

Sealz.Size = {
	Default = UDim2.new(0, 600, 0, 450),
	Small = UDim2.new(0, 550, 0, 350),	
	Large = UDim2.new(0, 800, 0, 625),	
};

Sealz.BlurringHandle = CurrentCamera;
Sealz.ScreenGui = SealzUI;
Sealz.AccentColor = Color3.fromRGB(115, 155, 208);
Sealz.Flags = {};

Sealz.Theme = {
	AccentColor = Color3.fromRGB(255, 255, 255),
	Background = Color3.fromRGB(25, 25, 25),
	Stroke = Color3.fromRGB(47, 47, 47),
	ItemBackground = Color3.fromRGB(15, 15, 15),
	ItemBackground2 = Color3.fromRGB(48, 48, 48),
	Highlight = Color3.fromRGB(158, 158, 158),
	White = Color3.fromRGB(255 , 255 , 255),
	Black = Color3.fromRGB(0, 0, 0)
}

function Sealz:SetFont(font)
	if typeof(font) == 'EnumItem' then
		font = Font.fromEnum(font)
	end
	
	Sealz.MediumFont = font;
	Sealz.BoldFont = font;
end
function Sealz:SetIcon(font)
	if typeof(font) == 'EnumItem' then
		font = Font.fromEnum(font)
	end

	Sealz.IconFont = font;
end
Sealz.Regisitry = {
	AccentColor = {},
	Background = {},
	Stroke = {},
	ItemBackground = {},
	ItemBackground2 = {},
	Highlight = {},
	White = {},

	MediumFont = {},
	BoldFont = {}
};

Sealz.RandomString = function()
	return string.char(math.random(32,120));
end;

function Sealz.Theme:Forest()
	Sealz.Theme = {
		AccentColor = Color3.fromRGB(196, 255, 210),
		Background = Color3.fromRGB(19, 25, 20),
		Stroke = Color3.fromRGB(44, 47, 44),
		ItemBackground = Color3.fromRGB(8, 15, 7),
		ItemBackground2 = Color3.fromRGB(40, 48, 42),
		Highlight = Color3.fromRGB(148, 158, 147),
		White = Color3.fromRGB(238, 255, 235),
		Black = Color3.fromRGB(0, 0, 0)
	};
end;

function Sealz.Theme:ElectricBlue()
	Sealz.Theme = {
		AccentColor = Color3.fromRGB(126, 238, 255),
		Background = Color3.fromRGB(17, 25, 25),
		Stroke = Color3.fromRGB(32, 45, 47),
		ItemBackground = Color3.fromRGB(11, 15, 15),
		ItemBackground2 = Color3.fromRGB(33, 48, 48),
		Highlight = Color3.fromRGB(112, 154, 158),
		White = Color3.fromRGB(192, 255, 245),
		Black = Color3.fromRGB(0, 0, 0)
	}
end;

function Sealz.Theme:Blood()
	Sealz.Theme = {
		AccentColor = Color3.fromRGB(255, 219, 220),
		Background = Color3.fromRGB(25, 20, 20),
		Stroke = Color3.fromRGB(47, 37, 38),
		ItemBackground = Color3.fromRGB(15, 11, 11),
		ItemBackground2 = Color3.fromRGB(48, 38, 38),
		Highlight = Color3.fromRGB(158, 128, 129),
		White = Color3.fromRGB(255, 201, 202),
		Black = Color3.fromRGB(0, 0, 0)
	}
end;

function Sealz.Theme:Retro()
	Sealz.Theme = {
		AccentColor = Color3.fromRGB(255, 97, 168),
		Background = Color3.fromRGB(25, 18, 24),
		Stroke = Color3.fromRGB(47, 34, 45),
		ItemBackground = Color3.fromRGB(15, 12, 14),
		ItemBackground2 = Color3.fromRGB(48, 34, 46),
		Highlight = Color3.fromRGB(158, 120, 151),
		White = Color3.fromRGB(255, 206, 248),
		Black = Color3.fromRGB(0, 0, 0)
	}
end;

function Sealz.Theme:Light()
	Sealz.Theme = {
		AccentColor = Color3.fromRGB(0, 0, 0),
		Background = Color3.fromRGB(217, 217, 217),
		Stroke = Color3.fromRGB(190, 190, 190),
		ItemBackground = Color3.fromRGB(241, 241, 241),
		ItemBackground2 = Color3.fromRGB(185, 185, 185),
		Highlight = Color3.fromRGB(95, 95, 95),
		White = Color3.fromRGB(66, 66, 66),
		Black = Color3.fromRGB(255, 255, 255)
	}
end;

Sealz.Base64 = {} do
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

	Sealz.Base64.Encode = function(data)
		return ((data:gsub('.', function(x) 
			local r,b='',x:byte()
			for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
			return r;
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b:sub(c+1,c+1)
		end)..({ '', '==', '=' })[#data%3+1])
	end;

	Sealz.Base64.Decode = function(data)
		data = string.gsub(data, '[^'..b..'=]', '')
		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r,f='',(b:find(x)-1)
			for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
			return r;
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end
			local c=0
			for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
			return string.char(c)
		end))
	end;
end;

function Sealz:IsMouseOverFrame(UI: Frame)
	if not UI then
		return;
	end;

	local AbsPos: Vector2, AbsSize: Vector2 = UI.AbsolutePosition, UI.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end;

function Sealz:IsPress(Input: InputObject , Target: Enum.KeyCode)
	if Input.KeyCode == Target or Input.KeyCode.Name == Target or Input.UserInputType == Target or Input.UserInputType.Name == Target or Input.UserInputType == Sealz.InputResolve[Target] or Input.KeyCode == Sealz.InputResolve[Target] then
		return true;
	end;
end;

function Sealz:AddInput(UI: Frame , Callback: ()->any)
	local Button = Instance.new('ImageButton',UI);

	Button.ZIndex = UI.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.ImageTransparency = 1;
	Button.Image = "";

	if Callback then
		local Signal = Button.MouseButton1Click:Connect(Callback);

		return Button , Signal;
	end;

	return Button;
end;

local BaseTween = TweenInfo.new(0.25);
function Sealz:Tween(UI: Frame , Info: TweenInfo , Property: {[string]:any})
	local Tween = TweenService:Create(UI , Info or BaseTween , Property);

	Tween:Play();

	return Tween;
end;

function Sealz:AddDrag(InputFrame: Frame, MoveFrame: Frame, Speed : number,dragable: Signal)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;
	local Tween = TweenInfo.new(Speed);

	local updateInput = function(input)
		if dragable and not dragable:Get() then return end;

		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		Sealz:Tween(MoveFrame,Tween,{
			Position = position
		});
	end;

	InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true;
			dragStart = input.Position;
			startPos = MoveFrame.Position;

			local input_end;
			input_end = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false;

					input_end:Disconnect();
				end
			end)
		end
	end);

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end);
end;

function Sealz:Rounding(num: number, numDecimalPlaces: number)
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end;


function Sealz:Format(Params,Fixed)
	Params = Params or {};

	local k = Params or {};

	for i,v in next , Fixed do
		k[i] = Params[i] or v;
	end;

	table.clear(Fixed);

	return k;
end;


function Sealz:GetCalculatePosition(planePos, planeNormal, rayOrigin, rayDirection)
	local n = planeNormal;
	local d = rayDirection;
	local v = rayOrigin - planePos;

	local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a = -num / den;

	return rayOrigin + (a * rayDirection);
end;

function Sealz:AddShadow(Frame: Frame)
	local shadow = Instance.new('UIShadow',Frame);
	shadow.BlurRadius = UDim.new(0,15);
	shadow.Transparency = 0.5

	return function(value)
		if value then
			Sealz:Tween(shadow,TweenInfo.new(0.2),{
				Transparency = 0.5
			})

		else
			Sealz:Tween(shadow,TweenInfo.new(0.2),{
				Transparency = 1
			})
		end;
	end
end;

function Sealz:AddBlurring(Frame , Signal)
	local Part = Instance.new('Part',Sealz.BlurringHandle);
	local DepthOfField = Instance.new('DepthOfFieldEffect',Sealz.cloneref(game:GetService('Lighting')));
	local BlockMesh = Instance.new("BlockMesh");

	BlockMesh.Parent = Part;

	Part.Material = Enum.Material.Glass;
	Part.Transparency = 1;
	Part.Reflectance = 1;
	Part.CastShadow = false;
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.CanQuery = false;
	Part.CollisionGroup = Sealz.RandomString();
	Part.Size = Vector3.new(1, 1, 1) * 0.01;
	Part.Color = Color3.fromRGB(0,0,0);

	DepthOfField.Enabled = true;
	DepthOfField.FarIntensity = 0;
	DepthOfField.FocusDistance = 0;
	DepthOfField.InFocusRadius = 1000;
	DepthOfField.NearIntensity = 1;
	DepthOfField.Name = Sealz.RandomString();

	Part.Name = Sealz.RandomString();

	local disconnect;

	local UpdateFunction = function()
		local IsWindowActive = Signal:Get();

		if IsWindowActive then

			Sealz:Tween(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 1
			})

			Sealz:Tween(Part,TweenInfo.new(0.1),{
				Transparency = 0.97,
				Size = Vector3.new(1, 1, 1) * 0.01;
			})

			Part.Parent = Sealz.BlurringHandle;
		else
			Sealz:Tween(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 0
			})

			Sealz:Tween(Part,TweenInfo.new(0.1),{
				Size = Vector3.zero,
				Transparency = 1.5,
			})

			Part.Parent = nil;

			return;
		end;

		if IsWindowActive then
			local corner0 = Frame.AbsolutePosition;
			local corner1 = corner0 + Frame.AbsoluteSize;

			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);

			local planeNormal = CurrentCamera.CFrame.LookVector;

			local pos0 = Sealz:GetCalculatePosition(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
			local pos1 = Sealz:GetCalculatePosition(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

			local size   = pos1 - pos0;
			local center = (pos0 + pos1) / 2;

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101;
			Part.CFrame = CurrentCamera.CFrame;
		end;
	end;

	local rbxsignal = CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(UpdateFunction)
	local loopThread = UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			pcall(UpdateFunction);
		end;
	end);

	local THREAD = task.spawn(function()
		while true do task.wait(0.1)
			pcall(UpdateFunction);
		end;
	end);

	disconnect = function()
		rbxsignal:Disconnect();
		loopThread:Disconnect();
		task.cancel(THREAD);
		Part:Destroy();
		DepthOfField:Destroy();
	end;

	Frame.Destroying:Connect(disconnect);

	return rbxsignal;
end;

function Sealz:OnKeyInputCallback(Key: Enum.KeyCode, Callback: () -> ())
	return UserInputService.InputBegan:Once(function(input,process)
		if not process and input.KeyCode == Key then
			Callback();
		end;
	end)
end

function Sealz:GetTextSize(text: TextLabel)
	return TextService:GetTextSize(text.Text:gsub("<.->", ""),text.TextSize , Enum.Font.Code , Vector2.new(math.huge,math.huge));
end;

function Sealz:OnShow(Frame: Frame,Follow: Frame)
	local Parent = Frame.Parent;

	if Follow.ClassName == "Frame" then
		local UPDATE = function()
			Frame.Visible = Follow.BackgroundTransparency <= 0.8;

			if Frame.Visible then
				Frame.Parent = Parent;
			else
				Frame.Parent = nil;
			end;
		end;

		Follow:GetPropertyChangedSignal("BackgroundTransparency"):Connect(UPDATE);
		UPDATE();
	end;
end;

function Sealz:CreateFloatWindow(zindex,custom)
	local FloatFrame = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UIShadow = Instance.new("UIShadow")
	local UICorner = Instance.new("UICorner")
	local UIListLayout = Instance.new("UIListLayout")

	FloatFrame.Name = "FloatFrame"
	FloatFrame.Parent = Sealz.ScreenGui
	FloatFrame.BackgroundColor3 = Sealz.Theme.Background
	FloatFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	FloatFrame.BorderSizePixel = 0
	FloatFrame.ClipsDescendants = true
	FloatFrame.Position = UDim2.new(1,1,1,1)
	FloatFrame.Size = UDim2.new(0,0,0,0)
	FloatFrame.ZIndex = (zindex and zindex + 700) or math.random(525,1250);
	FloatFrame.BackgroundTransparency = 1;

	Sealz:OnShow(FloatFrame,FloatFrame);

	UIStroke.Color = Sealz.Theme.Stroke
	UIStroke.Parent = FloatFrame

	UIShadow.BlurRadius = UDim.new(0, 20)
	UIShadow.Transparency = 0.500
	UIShadow.Parent = FloatFrame

	UICorner.Parent = FloatFrame

	UIListLayout.Parent = FloatFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local Signal = CreateSignal(false);
	local Regsisiter = Sealz:CreateBlockHandler(FloatFrame,Signal);

	Regsisiter.Signal = Signal;
	Regsisiter.BaseX = 200;
	Regsisiter.Root = FloatFrame;

	if custom then
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			Sealz:Tween(FloatFrame,Twnf ,{
				Size = UDim2.fromOffset(Regsisiter.BaseX, UIListLayout.AbsoluteContentSize.Y + 5)
			})
		end)
	end;

	Signal:Connect(function(value)
		if value then
			FloatFrame.Size = UDim2.fromOffset(Regsisiter.BaseX, UIListLayout.AbsoluteContentSize.Y + 5)
		end;

		Sealz:Tween(FloatFrame,Twnf,{
			BackgroundTransparency = value and 0.075 or 1;
		})

		Sealz:Tween(UIStroke,Twnf,{
			Transparency = value and 0 or 1;
		})

		Sealz:Tween(UIShadow,Twnf,{
			Transparency = value and 0.5 or 1;
		})


	end);

	function Regsisiter:SetWindow(value)
		if Signal:Get() == value then
			return
		end
		Signal:Fire(value);
	end;

	function Regsisiter:SetPosition(d)
		FloatFrame.Position = d;
	end;

	function Regsisiter:GetPosition()
		return FloatFrame.Position
	end

	function Regsisiter:GetValue()
		return FloatFrame.Position
	end

	function Regsisiter:SetValue(d)
		FloatFrame.Position = d;
	end

	function Regsisiter:SetSize(d)
		FloatFrame.Size = d;
	end;

	return Regsisiter;
end;

function Sealz:Line(frame: Frame)
	--[[local Line = Instance.new("Frame")

	Line.Name = "Line"
	Line.Parent = frame
	Line.BackgroundColor3 = Sealz.Theme.Stroke
	Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Line.BorderSizePixel = 0
	Line.Size = UDim2.new(1, -10, 0, 1)
	Line.ZIndex = frame.ZIndex + 1;	
	Line.BackgroundTransparency = 0.9]]
end;

local BlankFn = function() end;

function Sealz:CreateInputHandler(Frame: Frame, Signal: Signal)
	local Item = {};
	local ZIndex = Frame.ZIndex;

	Item.Zindex = ZIndex;

	function Item:AddToggle(arg: {Default: boolean , Callback: (any) -> any , Flag: string})
		arg = Sealz:Format(arg,{
			Default = false,
			Callback = BlankFn;
		});

		local Toggle = {};

		local ToggleFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local Box = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIShadow = Instance.new("UIShadow")

		ToggleFrame.Name = "ToggleFrame"
		ToggleFrame.Parent = Frame
		ToggleFrame.BackgroundColor3 = Sealz.Theme.ItemBackground
		ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleFrame.BorderSizePixel = 0
		ToggleFrame.Size = UDim2.new(0, 40, 0, 20)
		ToggleFrame.ZIndex = ZIndex + 17

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = ToggleFrame

		UICorner.TopLeftRadius = UDim.new(1, 0)
		UICorner.TopRightRadius = UDim.new(1, 0)
		UICorner.BottomLeftRadius = UDim.new(1, 0)
		UICorner.BottomRightRadius = UDim.new(1, 0)
		UICorner.Parent = ToggleFrame

		Box.Name = "Box"
		Box.Parent = ToggleFrame
		Box.AnchorPoint = Vector2.new(0.5, 0.5)
		Box.BackgroundColor3 = Sealz.Theme.AccentColor
		Box.BackgroundTransparency = 0.100
		Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Box.BorderSizePixel = 0
		Box.Position = UDim2.new(0.75, 0, 0.5, 0)
		Box.Size = UDim2.new(0, 15, 0, 15)
		Box.ZIndex = ZIndex + 18

		UICorner_2.TopLeftRadius = UDim.new(1, 0)
		UICorner_2.TopRightRadius = UDim.new(1, 0)
		UICorner_2.BottomLeftRadius = UDim.new(1, 0)
		UICorner_2.BottomRightRadius = UDim.new(1, 0)
		UICorner_2.Parent = Box

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.500
		UIShadow.Parent = ToggleFrame


		local OnLoad = function(value)
			Sealz:Tween(ToggleFrame,Twnf,{
				BackgroundTransparency = value and 0 or 1
			})

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = value and 0 or 1
			})

			Sealz:Tween(Box,Twnf,{
				BackgroundTransparency = value and 0.1 or 1
			})

			Sealz:Tween(UIShadow,Twnf,{
				Transparency = value and 0.5 or 1
			})
		end;

		OnLoad(Signal:Get());
		Signal:Connect(OnLoad);

		local Switch = function(value)
			Sealz:Tween(Box,Twnf,{
				Position = UDim2.new(value and 0.75 or 0.25, 0, 0.5, 0),
				BackgroundColor3 = value and Sealz.Theme.AccentColor or Sealz.Theme.ItemBackground2
			})
		end;

		Switch(arg.Default);

		Sealz:AddInput(ToggleFrame,function()
			arg.Default = not arg.Default;
			Switch(arg.Default);

			arg.Callback(arg.Default);
		end);

		function Toggle:SetCallback(fn)
			arg.Callback = fn;
		end;

		function Toggle:SetValue(f)
			arg.Default = f;
			Switch(arg.Default);

			arg.Callback(arg.Default);
		end;

		function Toggle:GetValue()
			return arg.Default;
		end;

		if arg.Flag or arg.Id then
			Sealz.Flags[arg.Flag or arg.Id] = Toggle;
		end;

		return Toggle;
	end;

	function Item:AddKeybind(arg: {Default: Enum.KeyCode | string, Mode: string, Blacklist: {Enum.KeyCode | Enum.UserInputType | string} , Callback: (any) -> any , Flag: string})
		arg = Sealz:Format(arg,{
			Default = nil,
			Mode = nil, -- "Hold" , "Toggle",
			Blacklist = {},
			Callback = BlankFn,
		});

		local KeybindFN = {};

		local KeybindFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local UIShadow = Instance.new("UIShadow")
		local Icon = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")
		local TextLabel = Instance.new("TextLabel")

		KeybindFrame.Name = "KeybindFrame"
		KeybindFrame.Parent = Frame
		KeybindFrame.BackgroundColor3 = Sealz.Theme.ItemBackground
		KeybindFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		KeybindFrame.BorderSizePixel = 0
		KeybindFrame.Size = UDim2.new(0, 30, 0, 20)
		KeybindFrame.ZIndex = ZIndex + 17

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = KeybindFrame

		UICorner.TopLeftRadius = UDim.new(0, 4)
		UICorner.TopRightRadius = UDim.new(0, 4)
		UICorner.BottomLeftRadius = UDim.new(0, 4)
		UICorner.BottomRightRadius = UDim.new(0, 4)
		UICorner.Parent = KeybindFrame

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.500
		UIShadow.Parent = KeybindFrame

		Icon.Name = "Icon"
		Icon.Parent = KeybindFrame
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Sealz.Theme.AccentColor
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 0, 0.5, 0)
		Icon.Size = UDim2.new(0, 18, 0, 18)
		Icon.ZIndex = ZIndex + 18
		Icon.FontFace = Sealz.IconFont
		Icon.Text = "keyboard"
		Icon.TextColor3 = Sealz.Theme.AccentColor
		Icon.TextSize = 12.000
		Icon.TextWrapped = true

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
		UIGradient.Rotation = 90
		UIGradient.Parent = Icon

		TextLabel.Parent = KeybindFrame
		TextLabel.AnchorPoint = Vector2.new(0, 0.5)
		TextLabel.BackgroundColor3 = Sealz.Theme.AccentColor
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0, 20, 0.5, 0)
		TextLabel.Size = UDim2.new(1, -25, 0, 15)
		TextLabel.ZIndex = ZIndex + 18
		TextLabel.FontFace = Sealz.BoldFont
		TextLabel.Text = Sealz:KeyToString(arg.Default);
		TextLabel.TextColor3 = Sealz.Theme.AccentColor
		TextLabel.TextSize = 12.000
		TextLabel.TextTransparency = 0.250
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		local OnLoad = function(value)
			Sealz:Tween(KeybindFrame,Twnf,{
				BackgroundTransparency = value and 0 or 1
			})

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = value and 0 or 1
			})

			Sealz:Tween(UIShadow,Twnf,{
				Transparency = value and 0.5 or 1
			})

			Sealz:Tween(TextLabel,Twnf,{
				TextTransparency = value and 0.250 or 1
			})


			Sealz:Tween(Icon,Twnf,{
				TextTransparency = value and 0 or 1
			})
		end;

		local Update = function()
			local size = Sealz:GetTextSize(TextLabel);

			Sealz:Tween(KeybindFrame,Twnf,{
				Size = UDim2.new(0, size.X + 35, 0, 20)
			})
		end;

		Update()

		OnLoad(Signal:Get());
		Signal:Connect(OnLoad);

		local IsBinding = false;
		KeybindFN.Root = KeybindFrame;

		local data = Sealz:AddInput(KeybindFrame,function()
			if IsBinding then
				return;
			end;

			IsBinding = true;

			TextLabel.Text = "...";

			Update();

			local Key = Sealz:WaitForInput(arg.Blacklist);

			local Text = Sealz:KeyToString(Key);

			TextLabel.Text = Text;

			arg.Default = Text;

			Update();

			task.spawn(arg.Callback,Text)

			IsBinding = false;
		end);

		if arg.Mode then
			local IsPressing = false;
			local Window = Sealz:CreateDropdownFloatWindow(ZIndex);


			do

				Window.Default = arg.Mode;
				Window.Values = {"Hold","Toggle","Always-On"};
				Window.Callback = function(data)
					arg.Mode = data;

					Update()
				end;

				Window:Update();

				Window:SetWindow(false);

				local OnDisable;

				local open = function()
					if OnDisable then
						OnDisable:Disconnect();
						OnDisable = nil;
					end;

					Window:SetWindow(true);
					local Positon = KeybindFrame.AbsolutePosition;

					Window:SetPosition(Sealz:ResolvePosition(UDim2.fromOffset(Positon.X + 25,Positon.Y)))

					OnDisable = UserInputService.InputBegan:Connect(function(Input)
						if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
							if not Sealz:IsMouseOverFrame(KeybindFrame) and not Sealz:IsMouseOverFrame(Window.Root) then
								Window:SetWindow(false);
								if OnDisable then
									OnDisable:Disconnect();
									OnDisable = nil;
								end;
							end;
						end;
					end)
				end;

				data.MouseButton2Click:Connect(function()
					open()
				end);
			end

			KeybindFN.InputBEG = UserInputService.InputBegan:Connect(function(Input)
				if arg.Mode == "Hold" then
					if Sealz:IsPress(Input , arg.Default) then
						IsPressing = true;
					end;
				elseif arg.Mode == "Toggle" then
					if Sealz:IsPress(Input , arg.Default) then
						IsPressing = not IsPressing;
					end;
				end;

				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					if not Sealz:IsMouseOverFrame(Window.Root) and Window.Signal:Get() then
						Window:SetWindow(false);
					end;
				end
			end);

			KeybindFN.InputOUT = UserInputService.InputEnded:Connect(function(Input)
				if arg.Mode == "Hold" then
					if Sealz:IsPress(Input , arg.Default) then
						IsPressing = false;
					end;
				end;
			end);

			function KeybindFN:IsActive()
				if arg.Mode == "Always-On" then
					return true;
				end;

				return IsPressing;
			end;
		else
			function KeybindFN:IsActive()
				local Current = UserInputService:GetKeysPressed();

				if Current and Current[1] then
					return Sealz:IsPress(Current[1],arg.Default);
				end;
			end;
		end;

		function KeybindFN:SetValue(val)
			arg.Default = val;
			arg.Callback(val)
		end;

		function KeybindFN:GetValue(val)
			return arg.Default;
		end

		if arg.Flag or arg.Id then
			Sealz.Flags[arg.Flag or arg.Id] = KeybindFN;
		end;


		return KeybindFN;
	end;

	function Item:AddSlider(arg)
		arg = Sealz:Format(arg,{
			Min = 0,
			Max = 10,
			Rounding = 0,
			Type = "",
			Default = 5,
			Callback = BlankFn,
			Size = 150
		});

		local SliderFN = {};

		local SliderFrame = Instance.new("Frame")
		local SliderFZ = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local UIShadow = Instance.new("UIShadow")
		local FilledFrame = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIGradient = Instance.new("UIGradient")
		local InputFZ = Instance.new("Frame")
		local UIStroke_2 = Instance.new("UIStroke")
		local UICorner_3 = Instance.new("UICorner")
		local UIShadow_2 = Instance.new("UIShadow")
		local TextBox = Instance.new("TextBox")

		SliderFrame.Name = "SliderFrame"
		SliderFrame.Parent = Frame
		SliderFrame.BackgroundColor3 = Sealz.Theme.AccentColor
		SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SliderFrame.BorderSizePixel = 0
		SliderFrame.Size = UDim2.new(0, arg.Size or 150, 0, 20)
		SliderFrame.BackgroundTransparency = 1;
		SliderFrame.ZIndex = ZIndex + 5
		SliderFrame.Active = true;

		SliderFZ.Name = "SliderFZ"
		SliderFZ.Parent = SliderFrame
		SliderFZ.BackgroundColor3 = Sealz.Theme.ItemBackground
		SliderFZ.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SliderFZ.BorderSizePixel = 0
		SliderFZ.ClipsDescendants = true
		SliderFZ.Position = UDim2.new(0, 0, 0, 5)
		SliderFZ.Size = UDim2.new(1, -25, 0, 10)
		SliderFZ.ZIndex = ZIndex + 17

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = SliderFZ

		UICorner.TopLeftRadius = UDim.new(0, 4)
		UICorner.TopRightRadius = UDim.new(0, 4)
		UICorner.BottomLeftRadius = UDim.new(0, 4)
		UICorner.BottomRightRadius = UDim.new(0, 4)
		UICorner.Parent = SliderFZ

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.500
		UIShadow.Parent = SliderFZ

		FilledFrame.Name = "FilledFrame"
		FilledFrame.Parent = SliderFZ
		FilledFrame.BackgroundColor3 = Sealz.Theme.AccentColor
		FilledFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		FilledFrame.BorderSizePixel = 0
		FilledFrame.Size = UDim2.new(0.5, 0, 1, 0)
		FilledFrame.ZIndex = ZIndex + 18

		UICorner_2.TopLeftRadius = UDim.new(1, 0)
		UICorner_2.TopRightRadius = UDim.new(1, 0)
		UICorner_2.BottomLeftRadius = UDim.new(1, 0)
		UICorner_2.BottomRightRadius = UDim.new(1, 0)
		UICorner_2.Parent = FilledFrame

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
		UIGradient.Rotation = 90
		UIGradient.Parent = FilledFrame

		InputFZ.Name = "InputFZ"
		InputFZ.Parent = SliderFrame
		InputFZ.AnchorPoint = Vector2.new(1, 0)
		InputFZ.BackgroundColor3 = Sealz.Theme.ItemBackground
		InputFZ.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputFZ.BorderSizePixel = 0
		InputFZ.Position = UDim2.new(1, 0, 0, 0)
		InputFZ.Size = UDim2.new(0, 20, 0, 20)
		InputFZ.ZIndex = ZIndex + 17

		UIStroke_2.Color = Sealz.Theme.Stroke
		UIStroke_2.Parent = InputFZ

		UICorner_3.TopLeftRadius = UDim.new(0, 4)
		UICorner_3.TopRightRadius = UDim.new(0, 4)
		UICorner_3.BottomLeftRadius = UDim.new(0, 4)
		UICorner_3.BottomRightRadius = UDim.new(0, 4)
		UICorner_3.Parent = InputFZ

		UIShadow_2.BlurRadius = UDim.new(0, 20)
		UIShadow_2.Transparency = 0.500
		UIShadow_2.Parent = InputFZ

		TextBox.Parent = InputFZ
		TextBox.BackgroundColor3 = Sealz.Theme.AccentColor
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Size = UDim2.new(1, 0, 1, 0)
		TextBox.ZIndex = ZIndex + 18
		TextBox.ClearTextOnFocus = false
		TextBox.FontFace = Sealz.BoldFont;
		TextBox.Text = "1%"
		TextBox.TextColor3 = Sealz.Theme.AccentColor
		TextBox.TextSize = 11.000
		TextBox.TextTransparency = 0.500
		SliderFN.Root = SliderFrame;


		local Update = function()
			local MaxSize = TextService:GetTextSize(string.rep("X" , arg.Rounding + 1) .. arg.Type,11,Enum.Font.Code,Vector2.new(math.huge,math.huge));

			TextBox.Text = tostring(arg.Default)..tostring(arg.Type);

			local extend = MaxSize.X + 15;

			Sealz:Tween(InputFZ,Twnf,{
				Size = UDim2.new(0, extend, 0, 20)
			});

			SliderFZ.Size = UDim2.new(1, -(extend + 5), 0, 10)

			Sealz:Tween(FilledFrame,Twnf,{
				Size = UDim2.new(
					(arg.Default - arg.Min) / (arg.Max - arg.Min)
					, 0, 1, 0)
			});

			arg.Callback(arg.Default);
		end;

		TextBox.FocusLost:Connect(function()
			local data = Sealz:ParseNumber(TextBox.Text);

			if data then
				arg.Default = Sealz:Rounding(math.clamp(data , arg.Min , arg.Max) , arg.Rounding);
			end

			Update();
		end)

		Update();

		local UpdateInput = function(Input)
			local SizeScale = math.clamp((((Input.Position.X) - SliderFZ.AbsolutePosition.X) / SliderFZ.AbsoluteSize.X), 0, 1);

			local Main = ((arg.Max - arg.Min) * SizeScale) + arg.Min;

			local Value = Sealz:Rounding(Main,arg.Rounding);

			arg.Default = Value;

			Update();
		end;

		Signal:Connect(function(value)
			Sealz:Tween(SliderFZ,Twnf,{
				BackgroundTransparency = value and 0 or 1
			})

			Sealz:Tween(InputFZ,Twnf,{
				BackgroundTransparency = value and 0 or 1
			})

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = value and 0 or 1
			})

			Sealz:Tween(UIStroke_2,Twnf,{
				Transparency = value and 0 or 1
			})

			Sealz:Tween(UIShadow,Twnf,{
				Transparency = value and 0.5 or 1
			})

			Sealz:Tween(UIShadow_2,Twnf,{
				Transparency = value and 0.5 or 1
			})

			Sealz:Tween(FilledFrame,Twnf,{
				BackgroundTransparency = value and 0 or 1
			})

			Sealz:Tween(TextBox,Twnf,{
				TextTransparency = value and 0.5 or 1
			})
		end);

		do
			local IsHold = false;

			SliderFZ.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsHold = true
					UpdateInput(Input)
				end
			end)

			SliderFZ.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if UserInputService.TouchEnabled then
						if not Sealz:IsMouseOverFrame(SliderFZ) then
							IsHold = false
						end;
					else
						IsHold = false
					end;
				end
			end)

			UserInputService.InputChanged:Connect(function(Input)
				if IsHold then
					if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
						if UserInputService.TouchEnabled then
							if not Sealz:IsMouseOverFrame(SliderFZ) then
								IsHold = false
							else
								UpdateInput(Input)
							end;
						else
							UpdateInput(Input)
						end;
					end;
				end;
			end);
		end;

		function SliderFN:GetValue()
			return arg.Default;
		end;

		function SliderFN:SetValue(c)
			arg.Default = c;
			Update()
		end;

		if arg.Flag or arg.Id then
			Sealz.Flags[arg.Flag or arg.Id] = SliderFN;
		end;

		return SliderFN;
	end;

	function Item:AddDropdown(arg)
		arg = Sealz:Format(arg,{
			Default = nil,
			Values = {"Item 1","Item 2","Item 3"},
			Multi = false,
			SearchBar = false,
			Callback = BlankFn;
		});

		if arg.Multi then
			arg.Default = arg.Default or {};
		end

		local DropdownFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local UIShadow = Instance.new("UIShadow")
		local TextLabel = Instance.new("TextLabel")
		local Icon = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")

		DropdownFrame.Name = "DropdownFrame"
		DropdownFrame.Parent = Frame
		DropdownFrame.BackgroundColor3 = Sealz.Theme.ItemBackground
		DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownFrame.BorderSizePixel = 0
		DropdownFrame.Size = UDim2.new(0, 55, 0, 20)
		DropdownFrame.ZIndex = ZIndex + 17

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = DropdownFrame

		UICorner.TopLeftRadius = UDim.new(0, 4)
		UICorner.TopRightRadius = UDim.new(0, 4)
		UICorner.BottomLeftRadius = UDim.new(0, 4)
		UICorner.BottomRightRadius = UDim.new(0, 4)
		UICorner.Parent = DropdownFrame

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.500
		UIShadow.Parent = DropdownFrame

		TextLabel.Parent = DropdownFrame
		TextLabel.AnchorPoint = Vector2.new(0, 0.5)
		TextLabel.BackgroundColor3 = Sealz.Theme.AccentColor
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0, 20, 0.5, 0)
		TextLabel.Size = UDim2.new(1, -25, 0, 15)
		TextLabel.ZIndex = ZIndex + 18
		TextLabel.FontFace = Sealz.BoldFont;
		TextLabel.Text = "Item"
		TextLabel.TextColor3 = Sealz.Theme.AccentColor
		TextLabel.TextSize = 12.000
		TextLabel.TextTransparency = 0.500
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.TextTruncate = Enum.TextTruncate.SplitWord;

		Icon.Name = "Icon"
		Icon.Parent = DropdownFrame
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Sealz.Theme.AccentColor
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 0, 0.5, 0)
		Icon.Size = UDim2.new(0, 18, 0, 18)
		Icon.ZIndex = ZIndex + 18
		Icon.FontFace = Sealz.IconFont
		Icon.Text = "list-bulleted"
		Icon.TextColor3 = Sealz.Theme.AccentColor
		Icon.TextSize = 12.000
		Icon.TextWrapped = true

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
		UIGradient.Rotation = 90
		UIGradient.Parent = Icon

		local Update = function()
			TextLabel.Text = Sealz:FormatTable(arg.Default);
			local size = Sealz:GetTextSize(TextLabel);

			Sealz:Tween(DropdownFrame,Twnf,{
				Size = UDim2.new(0, math.min(size.X + 25 , 125), 0, 20)
			});

			arg.Callback(arg.Default);
		end;

		Signal:Connect(function(value)
			Sealz:Tween(DropdownFrame,Twnf,{
				BackgroundTransparency = value and 0 or 1;
			})

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = value and 0 or 1;
			})

			Sealz:Tween(UIShadow,Twnf,{
				Transparency = value and 0.5 or 1;
			})

			Sealz:Tween(TextLabel,Twnf,{
				TextTransparency = value and 0.5 or 1;
			})

			Sealz:Tween(Icon,Twnf,{
				TextTransparency = value and 0 or 1;
			})
		end);

		Update();

		local Window = Sealz:CreateDropdownFloatWindow(ZIndex);

		Window.Multi = arg.Multi;
		Window.Default = arg.Default;
		Window.Values = arg.Values;
		Window.SearchBar = arg.SearchBar;
		Window.Callback = function(data)
			arg.Default = data;

			Update()
		end;

		Window:Update();

		Window:SetWindow(false);

		local OnDisable;
		local DropdownFN = {};

		Sealz:AddInput(DropdownFrame,function()
			if OnDisable then
				OnDisable:Disconnect();
				OnDisable = nil;
			end;

			local Positon = DropdownFrame.AbsolutePosition;

			Window:SetPosition(Sealz:ResolvePosition(UDim2.fromOffset(Positon.X,Positon.Y)))

			Window:SetWindow(true);

			OnDisable = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not Sealz:IsMouseOverFrame(DropdownFrame) and not Sealz:IsMouseOverFrame(Window.Root) then
						Window:SetWindow(false);
						if OnDisable then
							OnDisable:Disconnect();
							OnDisable = nil;
						end;
					end;
				end;
			end)
		end);

		function DropdownFN:GetValue()
			return arg.Default
		end

		function DropdownFN:SetValue(a)
			arg.Default = a;
			Window.Default = arg.Default;
			Window:Update();
			Update()
			arg.Callback(a)
		end;

		function DropdownFN:SetValues(d)
			arg.Values = d;
			Window.Values = arg.Values;
			Window:Update();
		end;

		if arg.Flag or arg.Id then
			Sealz.Flags[arg.Flag or arg.Id] = DropdownFN;
		end;

		return DropdownFN;
	end;

	function Item:AddColorPicker(arg)
		arg = Sealz:Format(arg,{
			Default = Color3.new(1,1,1),
			Callback = BlankFn,
		});

		local ColorFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local UIShadow = Instance.new("UIShadow")
		local ColorFN = {};

		ColorFrame.Name = "ColorFrame"
		ColorFrame.Parent = Frame
		ColorFrame.BackgroundColor3 = arg.Default
		ColorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorFrame.BorderSizePixel = 0
		ColorFrame.Size = UDim2.new(0, 20, 0, 20)
		ColorFrame.ZIndex = ZIndex + 17

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = ColorFrame

		UICorner.TopLeftRadius = UDim.new(0, 4)
		UICorner.TopRightRadius = UDim.new(0, 4)
		UICorner.BottomLeftRadius = UDim.new(0, 4)
		UICorner.BottomRightRadius = UDim.new(0, 4)
		UICorner.Parent = ColorFrame

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.500
		UIShadow.Parent = ColorFrame

		local Window = Sealz:CreateColorPickerFloatWindow(ZIndex);

		Window:Set(arg.Default:ToHSV());

		Window.Callback = function(val)
			ColorFrame.BackgroundColor3 = val;

			arg.Default = val;

			arg.Callback(val)
		end;

		Signal:Connect(function(val)
			Sealz:Tween(ColorFrame,Twnf,{
				BackgroundTransparency = val and 0 or 1
			})	

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = val and 0 or 1
			})	

			Sealz:Tween(UIShadow,Twnf,{
				Transparency = val and 0.5 or 1
			})	
		end);

		local OnDisable;

		Sealz:AddInput(ColorFrame,function()
			if OnDisable then
				OnDisable:Disconnect();
				OnDisable = nil;
			end;

			Window:SetPosition(Sealz:ResolvePosition(UDim2.fromOffset(
				ColorFrame.AbsolutePosition.X + 15,
				ColorFrame.AbsolutePosition.Y + 15)));

			Window:SetWindow(true);

			OnDisable = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not Sealz:IsMouseOverFrame(ColorFrame) and not Sealz:IsMouseOverFrame(Window.Root) then
						Window:SetWindow(false);
						if OnDisable then
							OnDisable:Disconnect();
							OnDisable = nil;
						end;
					end;
				end;
			end)
		end);

		function ColorFN:GetValue()
			return arg.Default
		end

		function ColorFN:SetValue(a)
			arg.Default = a;
			ColorFrame.BackgroundColor3 = a;
			Window:Set(a:ToHSV());
		end;

		if arg.Flag or arg.Id then
			Sealz.Flags[arg.Flag or arg.Id] = ColorFN;
		end;

		return ColorFN;
	end;

	function Item:AddOption(BaseX)
		local Icon = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")

		Icon.Name = "Icon"
		Icon.Parent = Frame
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Sealz.Theme.AccentColor
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 0, 0.5, 0)
		Icon.Size = UDim2.new(0, 18, 0, 18)
		Icon.ZIndex = ZIndex + 18
		Icon.FontFace = Sealz.IconFont
		Icon.Text = "two-sliders-horizontal"
		Icon.TextColor3 = Sealz.Theme.AccentColor
		Icon.TextSize = 17.000
		Icon.TextTransparency = 0.500
		Icon.TextWrapped = true

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
		UIGradient.Rotation = 90
		UIGradient.Parent = Icon

		Signal:Connect(function(val)
			Sealz:Tween(Icon,Twnf,{
				TextTransparency = val and 0.500 or 1
			});
		end)
		local optf = Sealz:CreateFloatWindow(ZIndex);
		local OnDisable;

		optf.BaseX = BaseX or 150;

		Sealz:AddInput(Icon,function()
			if OnDisable then
				OnDisable:Disconnect();
				OnDisable = nil;
			end;

			optf:SetWindow(true);
			optf:SetPosition(Sealz:ResolvePosition(UDim2.fromOffset(Icon.AbsolutePosition.X,Icon.AbsolutePosition.Y)));

			OnDisable = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not Sealz:IsMouseOverFrame(Icon) and not Sealz:IsMouseOverFrame(optf.Root) then
						optf:SetWindow(false);
						if OnDisable then
							OnDisable:Disconnect();
							OnDisable = nil;
						end;
					end;
				end;
			end)
		end)

		return optf;
	end;

	function Item:AddInput(arg)
		arg = Sealz:Format(arg,{
			Default = "",
			Placeholder = "",
			Numeric = false,
			Callback = function() end,
		});

		local InputFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local UIShadow = Instance.new("UIShadow")
		local TextBox = Instance.new("TextBox")

		InputFrame.Name = "InputFrame"
		InputFrame.Parent = Frame
		InputFrame.AnchorPoint = Vector2.new(1, 0)
		InputFrame.BackgroundColor3 = Sealz.Theme.ItemBackground
		InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputFrame.BorderSizePixel = 0
		InputFrame.Position = UDim2.new(1, 0, 0, 0)
		InputFrame.Size = UDim2.new(0, 20, 0, 20)
		InputFrame.ZIndex = ZIndex + 17

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = InputFrame

		UICorner.TopLeftRadius = UDim.new(0, 4)
		UICorner.TopRightRadius = UDim.new(0, 4)
		UICorner.BottomLeftRadius = UDim.new(0, 4)
		UICorner.BottomRightRadius = UDim.new(0, 4)
		UICorner.Parent = InputFrame

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.500
		UIShadow.Parent = InputFrame

		TextBox.Parent = InputFrame
		TextBox.BackgroundColor3 = Sealz.Theme.AccentColor
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Size = UDim2.new(1, 0, 1, 0)
		TextBox.ZIndex = ZIndex + 18
		TextBox.ClearTextOnFocus = false
		TextBox.FontFace = Sealz.BoldFont
		TextBox.Text = tostring(arg.Default)
		TextBox.PlaceholderText = tostring(arg.Placeholder);
		TextBox.TextColor3 = Sealz.Theme.AccentColor
		TextBox.TextSize = 11.000
		TextBox.TextTransparency = 0.500

		local Update = function()
			local sea = Sealz:GetTextSize(TextBox);
			local min = TextService:GetTextSize(TextBox.PlaceholderText,11,Enum.Font.Code,Vector2.new(math.huge,math.huge));

			Sealz:Tween(InputFrame,Twnf,{
				Size = UDim2.new(0, math.max(sea.X + 5,min.X + 5), 0, 20)
			})
		end

		Signal:Connect(function(val)
			Sealz:Tween(InputFrame,Twnf,{
				BackgroundTransparency = if val then 0 else 1
			})

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = if val then 0 else 1
			})

			Sealz:Tween(UIShadow,Twnf,{
				Transparency = if val then 0.5 else 1
			})

			Sealz:Tween(TextBox,Twnf,{
				TextTransparency = if val then 0.5 else 1
			})
		end);

		Update();

		TextBox:GetPropertyChangedSignal('Text'):Connect(function()
			local txt = (arg.Numeric and Sealz:ParseNumber(TextBox.Text) or false) or (not arg.Numeric and TextBox.Text);

			if txt then
				arg.Default = txt;
				task.spawn(arg.Callback,txt);
				Update();
			else
				TextBox.Text = string.gsub(TextBox.Text, '[^0-9.]', '');

				arg.Default = arg.Numeric and tonumber(TextBox.Text) or TextBox.Text;
			end
		end);

		local InputFN = {};

		function InputFN:GetValue()
			return arg.Default
		end

		function InputFN:SetValue(a)
			TextBox.Text = tostring(a);
			arg.Default = a;
			Update();
			arg.Callback(a);
		end;

		if arg.Flag or arg.Id then
			Sealz.Flags[arg.Flag or arg.Id] = InputFN;
		end;

		return InputFN;
	end;

	function Item:AddButton(Content: string, IconStr: string , Callback: ()-> ())
		local ButtonFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local UIShadow = Instance.new("UIShadow")
		local TextLabel = Instance.new("TextLabel")
		local Icon = Instance.new("TextLabel")

		ButtonFrame.Name = "ButtonFrame"
		ButtonFrame.Parent = Frame
		ButtonFrame.BackgroundColor3 = Sealz.Theme.Background
		ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonFrame.BorderSizePixel = 0
		ButtonFrame.Size = UDim2.new(0, 55, 0, 20)
		ButtonFrame.ZIndex =  ZIndex + 17

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = ButtonFrame

		UICorner.TopLeftRadius = UDim.new(0, 4)
		UICorner.TopRightRadius = UDim.new(0, 4)
		UICorner.BottomLeftRadius = UDim.new(0, 4)
		UICorner.BottomRightRadius = UDim.new(0, 4)
		UICorner.Parent = ButtonFrame

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.500
		UIShadow.Parent = ButtonFrame

		TextLabel.Parent = ButtonFrame
		TextLabel.AnchorPoint = Vector2.new(0, 0.5)
		TextLabel.BackgroundColor3 = Sealz.Theme.AccentColor
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0, 20, 0.5, 0)
		TextLabel.Size = UDim2.new(1, -25, 0, 15)
		TextLabel.ZIndex = ZIndex + 18
		TextLabel.FontFace = Sealz.BoldFont
		TextLabel.Text = Content
		TextLabel.TextColor3 = Sealz.Theme.AccentColor
		TextLabel.TextSize = 12.000
		TextLabel.TextTransparency = 0.500
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		Icon.Name = "Icon"
		Icon.Parent = ButtonFrame
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Sealz.Theme.AccentColor
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 0, 0.5, 0)
		Icon.Size = UDim2.new(0, 18, 0, 18)
		Icon.ZIndex = 18
		Icon.FontFace = Sealz.IconFont
		Icon.Text = IconStr or "mouse-button-left"
		Icon.TextColor3 = Sealz.Theme.AccentColor
		Icon.TextSize = 12.000
		Icon.TextWrapped = true

		Signal:Connect(function(val)
			Sealz:Tween(ButtonFrame,Twnf,{
				BackgroundTransparency = val and 0 or 1
			})	

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = val and 0 or 1
			})

			Sealz:Tween(UIShadow,Twnf,{
				Transparency = val and 0.5 or 1
			})

			Sealz:Tween(TextLabel,Twnf,{
				TextTransparency = val and 0.5 or 1
			})

			Sealz:Tween(Icon,Twnf,{
				TextTransparency = val and 0 or 1
			})
		end);

		local bth = Sealz:AddInput(ButtonFrame,function()
			Callback();
		end)

		bth.MouseEnter:Connect(function()
			Sealz:Tween(ButtonFrame,Twnf,{
				BackgroundColor3 = Sealz.Theme.ItemBackground
			})
		end)

		bth.MouseLeave:Connect(function()
			Sealz:Tween(ButtonFrame,Twnf,{
				BackgroundColor3 = Sealz.Theme.Background
			})
		end)
	end;

	return Item;
end;

function Sealz:CreateColorPickerFloatWindow(ZIndex)
	local FloatColorFrame = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UIShadow = Instance.new("UIShadow")
	local UICorner = Instance.new("UICorner")
	local PickerFrame = Instance.new("Frame")
	local MainColorFrame = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_2 = Instance.new("UICorner")
	local WhiteColorFrame = Instance.new("Frame")
	local UIGradient_2 = Instance.new("UIGradient")
	local UICorner_3 = Instance.new("UICorner")
	local BlackColorFrame = Instance.new("Frame")
	local UIGradient_3 = Instance.new("UIGradient")
	local UICorner_4 = Instance.new("UICorner")
	local UIShadow_2 = Instance.new("UIShadow")
	local UIStroke_2 = Instance.new("UIStroke")
	local UICorner_5 = Instance.new("UICorner")
	local PickerCircle = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local UICorner_6 = Instance.new("UICorner")
	local ColorZonepicker = Instance.new("Frame")
	local UIGradient_4 = Instance.new("UIGradient")
	local UICorner_7 = Instance.new("UICorner")
	local ColorSlider = Instance.new("Frame")
	local UIStroke_4 = Instance.new("UIStroke")
	local UICorner_8 = Instance.new("UICorner")
	local HexFrame = Instance.new("Frame")
	local UIStroke_5 = Instance.new("UIStroke")
	local UICorner_9 = Instance.new("UICorner")
	local UIShadow_3 = Instance.new("UIShadow")
	local TextBox = Instance.new("TextBox")

	FloatColorFrame.Name = "FloatColorFrame"
	FloatColorFrame.Parent = Sealz.ScreenGui
	FloatColorFrame.BackgroundColor3 = Sealz.Theme.Background
	FloatColorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	FloatColorFrame.BorderSizePixel = 0
	FloatColorFrame.ClipsDescendants = true
	FloatColorFrame.Position = UDim2.new(255,0,255,0)
	FloatColorFrame.Size = UDim2.new(0, 250, 0, 250)
	FloatColorFrame.ZIndex = ZIndex + 525

	Sealz:OnShow(FloatColorFrame,FloatColorFrame);

	UIStroke.Color = Sealz.Theme.Stroke
	UIStroke.Parent = FloatColorFrame

	UIShadow.BlurRadius = UDim.new(0, 20)
	UIShadow.Transparency = 0.500
	UIShadow.Parent = FloatColorFrame

	UICorner.Parent = FloatColorFrame

	PickerFrame.Name = "PickerFrame"
	PickerFrame.Parent = FloatColorFrame
	PickerFrame.BackgroundColor3 = Color3.new(1,1,1)
	PickerFrame.BackgroundTransparency = 1.000
	PickerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PickerFrame.BorderSizePixel = 0
	PickerFrame.Position = UDim2.new(0, 15, 0, 15)
	PickerFrame.Size = UDim2.new(0, 190, 0, 190)
	PickerFrame.ZIndex = ZIndex + 526

	MainColorFrame.Name = "MainColorFrame"
	MainColorFrame.Parent = PickerFrame
	MainColorFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
	MainColorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainColorFrame.BorderSizePixel = 0
	MainColorFrame.Size = UDim2.new(1, 0, 1, 0)
	MainColorFrame.ZIndex = ZIndex + 526

	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient.Parent = MainColorFrame

	UICorner_2.Parent = MainColorFrame

	WhiteColorFrame.Name = "WhiteColorFrame"
	WhiteColorFrame.Parent = PickerFrame
	WhiteColorFrame.BackgroundColor3 = Color3.new(1,1,1)
	WhiteColorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WhiteColorFrame.BorderSizePixel = 0
	WhiteColorFrame.Size = UDim2.new(1, 0, 1, 0)
	WhiteColorFrame.ZIndex = ZIndex + 526

	UIGradient_2.Rotation = -180
	UIGradient_2.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient_2.Parent = WhiteColorFrame

	UICorner_3.Parent = WhiteColorFrame

	BlackColorFrame.Name = "BlackColorFrame"
	BlackColorFrame.Parent = PickerFrame
	BlackColorFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	BlackColorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BlackColorFrame.BorderSizePixel = 0
	BlackColorFrame.Size = UDim2.new(1, 0, 1, 0)
	BlackColorFrame.ZIndex = ZIndex + 527

	UIGradient_3.Rotation = 90
	UIGradient_3.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient_3.Parent = BlackColorFrame

	UICorner_4.Parent = BlackColorFrame

	UIShadow_2.BlurRadius = UDim.new(0, 20)
	UIShadow_2.Transparency = 0.500
	UIShadow_2.Parent = PickerFrame

	UIStroke_2.Color = Sealz.Theme.Stroke
	UIStroke_2.Parent = PickerFrame

	UICorner_5.Parent = PickerFrame

	PickerCircle.Name = "PickerCircle"
	PickerCircle.Parent = PickerFrame
	PickerCircle.AnchorPoint = Vector2.new(0.5, 0.5)
	PickerCircle.BackgroundColor3 = Color3.new(1,1,1)
	PickerCircle.BackgroundTransparency = 1.000
	PickerCircle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PickerCircle.BorderSizePixel = 0
	PickerCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
	PickerCircle.Size = UDim2.new(0, 10, 0, 10)
	PickerCircle.ZIndex = ZIndex + 529

	UIStroke_3.Color = Sealz.Theme.AccentColor
	UIStroke_3.Parent = PickerCircle

	UICorner_6.TopLeftRadius = UDim.new(1, 0)
	UICorner_6.TopRightRadius = UDim.new(1, 0)
	UICorner_6.BottomLeftRadius = UDim.new(1, 0)
	UICorner_6.BottomRightRadius = UDim.new(1, 0)
	UICorner_6.Parent = PickerCircle

	ColorZonepicker.Name = "ColorZonepicker"
	ColorZonepicker.Parent = FloatColorFrame
	ColorZonepicker.AnchorPoint = Vector2.new(1, 0)
	ColorZonepicker.BackgroundColor3 = Color3.new(1,1,1)
	ColorZonepicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorZonepicker.BorderSizePixel = 0
	ColorZonepicker.Position = UDim2.new(1, -15, 0, 15)
	ColorZonepicker.Size = UDim2.new(0, 20, 0, 190)
	ColorZonepicker.ZIndex = ZIndex + 526

	UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient_4.Rotation = 90
	UIGradient_4.Parent = ColorZonepicker

	UICorner_7.TopLeftRadius = UDim.new(0, 4)
	UICorner_7.TopRightRadius = UDim.new(0, 4)
	UICorner_7.BottomLeftRadius = UDim.new(0, 4)
	UICorner_7.BottomRightRadius = UDim.new(0, 4)
	UICorner_7.Parent = ColorZonepicker

	ColorSlider.Name = "ColorSlider"
	ColorSlider.Parent = ColorZonepicker
	ColorSlider.AnchorPoint = Vector2.new(0.5, 0)
	ColorSlider.BackgroundColor3 = Color3.new(1,1,1)
	ColorSlider.BackgroundTransparency = 1.000
	ColorSlider.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorSlider.BorderSizePixel = 0
	ColorSlider.Position = UDim2.new(0.5, 0, 0, 0)
	ColorSlider.Size = UDim2.new(1, 5, 0, 5)
	ColorSlider.ZIndex = ZIndex + 527

	UIStroke_4.Thickness = 2.000
	UIStroke_4.Parent = ColorSlider

	UICorner_8.TopLeftRadius = UDim.new(0, 4)
	UICorner_8.TopRightRadius = UDim.new(0, 4)
	UICorner_8.BottomLeftRadius = UDim.new(0, 4)
	UICorner_8.BottomRightRadius = UDim.new(0, 4)
	UICorner_8.Parent = ColorSlider

	HexFrame.Name = "HexFrame"
	HexFrame.Parent = FloatColorFrame
	HexFrame.AnchorPoint = Vector2.new(0.5, 1)
	HexFrame.BackgroundColor3 = Sealz.Theme.ItemBackground
	HexFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HexFrame.BorderSizePixel = 0
	HexFrame.ClipsDescendants = true
	HexFrame.Position = UDim2.new(0.5, 0, 1, -15)
	HexFrame.Size = UDim2.new(1, -30, 0, 20)
	HexFrame.ZIndex = ZIndex + 526

	UIStroke_5.Color = Sealz.Theme.Stroke
	UIStroke_5.Parent = HexFrame

	UICorner_9.TopLeftRadius = UDim.new(0, 4)
	UICorner_9.TopRightRadius = UDim.new(0, 4)
	UICorner_9.BottomLeftRadius = UDim.new(0, 4)
	UICorner_9.BottomRightRadius = UDim.new(0, 4)
	UICorner_9.Parent = HexFrame

	UIShadow_3.BlurRadius = UDim.new(0, 20)
	UIShadow_3.Transparency = 0.500
	UIShadow_3.Parent = HexFrame

	TextBox.Parent = HexFrame
	TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
	TextBox.BackgroundColor3 = Sealz.Theme.AccentColor
	TextBox.BackgroundTransparency = 1.000
	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextBox.Size = UDim2.new(1, 0, 1, 0)
	TextBox.ZIndex =  ZIndex + 527
	TextBox.ClearTextOnFocus = false
	TextBox.Font = Enum.Font.Code
	TextBox.Text = "#ffffff"
	TextBox.TextColor3 = Sealz.Theme.AccentColor
	TextBox.TextSize = 12.000



	local Onrender = function(value)
		Sealz:Tween(FloatColorFrame,Twnf,{
			BackgroundTransparency = value and 0 or 1
		});

		Sealz:Tween(UIStroke,Twnf,{
			Transparency = value and 0 or 1
		});

		Sealz:Tween(UIShadow,Twnf,{
			Transparency = value and 0.5 or 1
		});

		Sealz:Tween(MainColorFrame,Twnf,{
			BackgroundTransparency = value and 0 or 1
		});

		Sealz:Tween(WhiteColorFrame,Twnf,{
			BackgroundTransparency = value and 0 or 1
		});

		Sealz:Tween(BlackColorFrame,Twnf,{
			BackgroundTransparency = value and 0 or 1
		});

		Sealz:Tween(UIShadow_2,Twnf,{
			Transparency = value and 0.5 or 1
		});

		Sealz:Tween(UIStroke_2,Twnf,{
			Transparency = value and 0 or 1
		});

		Sealz:Tween(UIStroke_4,Twnf,{
			Transparency = value and 0 or 1
		});

		Sealz:Tween(UIStroke_5,Twnf,{
			Transparency = value and 0 or 1
		});

		Sealz:Tween(HexFrame,Twnf,{
			BackgroundTransparency = value and 0 or 1
		});

		Sealz:Tween(TextBox,Twnf,{
			TextTransparency = value and 0 or 1
		});

		Sealz:Tween(UIStroke_3,Twnf,{
			Transparency = value and 0 or 1
		});

		Sealz:Tween(ColorZonepicker,Twnf,{
			BackgroundTransparency = value and 0 or 1
		});

		Sealz:Tween(ColorZonepicker,Twnf,{
			BackgroundTransparency = value and 0 or 1
		});
	end;

	Onrender(false);

	local Color = {};

	Color.H = 1;
	Color.S = 1;
	Color.V = 1;

	TextBox.FocusLost:Connect(function()
		local hex = TextBox.Text:gsub("#","");
		local m,d = pcall(Color3.fromHex , hex);

		if m then
			Color:Set(d:ToHSV());
		end;
	end)

	function Color:SetWindow(value)
		Onrender(value);
	end;

	function Color:SetPosition(value)
		FloatColorFrame.Position = value
	end;

	function Color:Update()
		local FullColor = Color3.fromHSV(Color.H,Color.S,Color.V);
		local Highlight = Color3.fromHSV(Color.H,1,1);

		Sealz:Tween(MainColorFrame,Twnf,{
			BackgroundColor3 = Highlight
		});

		local hex = FullColor:ToHex();

		TextBox.Text = "#"..hex;

		Sealz:Tween(PickerCircle,Twnf,{
			Position = UDim2.fromScale(Color.S , 1 - Color.V)
		});

		Sealz:Tween(ColorSlider,Twnf,{
			Position = UDim2.new(0.5 ,0 , Color.H ,0)
		});

		if Color.Callback then
			Color.Callback(FullColor)
		end;
	end;

	function Color:Set(H,S,V)
		Color.H = H;
		Color.S = S;
		Color.V = V;

		Color:Update();
	end;

	Color.Root = FloatColorFrame

	local SPAWN_THREAD;
	local IsHold = false;

	FloatColorFrame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			IsHold = true
		end;
	end);

	FloatColorFrame.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			IsHold = false;
		end;
	end)

	ColorZonepicker.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			IsHold = true

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsHold) do task.wait()
				local ColorY = ColorZonepicker.AbsolutePosition.Y
				local ColorYM = ColorY + ColorZonepicker.AbsoluteSize.Y;
				local Value = math.clamp(Mouse.Y, ColorY, ColorYM)
				local Code = ((Value - ColorY) / (ColorYM - ColorY));

				Color.H = Code;

				Color:Update();
			end;
		end;
	end);

	PickerFrame.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsHold) do task.wait();
				local PosX = PickerFrame.AbsolutePosition.X
				local ScaleX = PosX + PickerFrame.AbsoluteSize.X
				local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), PickerFrame.AbsolutePosition.Y
				local ScaleY = PosY + PickerFrame.AbsoluteSize.Y
				local Vals = math.clamp(Mouse.Y, PosY, ScaleY)

				Color.S = (Value - PosX) / (ScaleX - PosX);
				Color.V = (1 - ((Vals - PosY) / (ScaleY - PosY)));

				Color:Update();
			end
		end
	end)

	Color:Update()

	return Color;
end;

function Sealz:CreateDropdownFloatWindow(ZIndex)
	local DropdownFloatFrame = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UIShadow = Instance.new("UIShadow")
	local UICorner = Instance.new("UICorner")
	local SearchFrame = Instance.new("Frame")
	local UIStroke_2 = Instance.new("UIStroke")
	local UICorner_2 = Instance.new("UICorner")
	local UIShadow_2 = Instance.new("UIShadow")
	local TextBox = Instance.new("TextBox")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")

	DropdownFloatFrame.Name = "DropdownFloatFrame"
	DropdownFloatFrame.Parent = Sealz.ScreenGui
	DropdownFloatFrame.BackgroundColor3 = Sealz.Theme.Background
	DropdownFloatFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DropdownFloatFrame.BorderSizePixel = 0
	DropdownFloatFrame.ClipsDescendants = true
	DropdownFloatFrame.Position = UDim2.new(255,0,255,0)
	DropdownFloatFrame.Size = UDim2.new(0, 193, 0, 135)
	DropdownFloatFrame.ZIndex = ZIndex + 525
	DropdownFloatFrame.Visible = false;
	
	Sealz:OnShow(DropdownFloatFrame,DropdownFloatFrame);
	DropdownFloatFrame.Parent = nil;

	UIStroke.Color = Sealz.Theme.Stroke
	UIStroke.Parent = DropdownFloatFrame

	UIShadow.BlurRadius = UDim.new(0, 20)
	UIShadow.Transparency = 0.500
	UIShadow.Parent = DropdownFloatFrame

	UICorner.Parent = DropdownFloatFrame

	SearchFrame.Name = "SearchFrame"
	SearchFrame.Parent = DropdownFloatFrame
	SearchFrame.AnchorPoint = Vector2.new(0.5, 0)
	SearchFrame.BackgroundColor3 = Sealz.Theme.ItemBackground
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.ClipsDescendants = true
	SearchFrame.Position = UDim2.new(0.5, 0, 0, 10)
	SearchFrame.Size = UDim2.new(1, -25, 0, 20)
	SearchFrame.ZIndex = ZIndex + 526

	UIStroke_2.Color = Sealz.Theme.Stroke
	UIStroke_2.Parent = SearchFrame

	UICorner_2.TopLeftRadius = UDim.new(0, 4)
	UICorner_2.TopRightRadius = UDim.new(0, 4)
	UICorner_2.BottomLeftRadius = UDim.new(0, 4)
	UICorner_2.BottomRightRadius = UDim.new(0, 4)
	UICorner_2.Parent = SearchFrame

	UIShadow_2.BlurRadius = UDim.new(0, 20)
	UIShadow_2.Transparency = 0.500
	UIShadow_2.Parent = SearchFrame

	TextBox.Parent = SearchFrame
	TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
	TextBox.BackgroundColor3 = Sealz.Theme.AccentColor
	TextBox.BackgroundTransparency = 1.000
	TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextBox.BorderSizePixel = 0
	TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextBox.Size = UDim2.new(1, 0, 1, 0)
	TextBox.ZIndex =ZIndex + 527
	TextBox.Font = Enum.Font.Code
	TextBox.PlaceholderText = "Search"
	TextBox.Text = ""
	TextBox.TextColor3 = Sealz.Theme.AccentColor
	TextBox.TextSize = 12.000

	ScrollingFrame.Parent = DropdownFloatFrame
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
	ScrollingFrame.BackgroundColor3 = Sealz.Theme.AccentColor
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 35)
	ScrollingFrame.Size = UDim2.new(1, -25, 1, -40)
	ScrollingFrame.ZIndex =ZIndex + 528
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.ScrollBarThickness = 0
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local signal = CreateSignal(false);
	local Data = {};
	Data.Signal = signal;
	Data.SearchBar = false;
	Data.Root = DropdownFloatFrame;
	Data.HightestX = 200;

	signal:Connect(function(value)


		if not Data.SearchBar then
			SearchFrame.Size = UDim2.new(1, -25, 0, 20)
			SearchFrame.Visible = false;
			ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 5)
			ScrollingFrame.Size = UDim2.new(1, -25, 1, -10)
			DropdownFloatFrame.Size = UDim2.new(0, Data.HightestX, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 10 , 255));
		else
			ScrollingFrame.Position = UDim2.new(0.5, 0, 0, 35)
			SearchFrame.Size = UDim2.new(1, -25, 0, 20)
			SearchFrame.Visible = true;
			ScrollingFrame.Size = UDim2.new(1, -25, 1, -40)
			DropdownFloatFrame.Size = UDim2.new(0, Data.HightestX, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 40 , 255));
		end;

		Sealz:Tween(DropdownFloatFrame,Twnf,{
			BackgroundTransparency = value and 0 or 1,
		});

		Sealz:Tween(UIStroke,Twnf,{
			Transparency = value and 0 or 1,
		});

		Sealz:Tween(UIShadow,Twnf,{
			Transparency = value and 0.5 or 1,
		});

		Sealz:Tween(SearchFrame,Twnf,{
			BackgroundTransparency = value and 0 or 1,
		});

		Sealz:Tween(UIStroke_2,Twnf,{
			Transparency = value and 0 or 1,
		});

		Sealz:Tween(UIShadow_2,Twnf,{
			Transparency = value and 0.5 or 1,
		});

		Sealz:Tween(TextBox,Twnf,{
			TextTransparency = value and 0 or 1,
		});
	end);

	signal:Fire(false);

	function Data:SetWindow(value)
		if signal:Get() == value then
			return
		end

		signal:Fire(value)

		if not value then
			TextBox.Text = "";
		end
	end;

	TextBox:GetPropertyChangedSignal('Text'):Connect(function()
		if SearchFrame.Visible then
			local byte = TextBox.Text;

			for i,v in next , ScrollingFrame:GetChildren() do
				if v:IsA('Frame') then
					if v:GetAttribute("txt") and byte:byte() then
						local match = string.lower(v:GetAttribute("txt"));

						if string.find(match , TextBox.Text:lower() , 1 , true) then
							v.Visible = true;
						else
							v.Visible = false;
						end
					else
						v.Visible = true;
					end
				end;
			end
		end;
	end);

	function Data:SetPosition(value)
		DropdownFloatFrame.Position = value;
	end;

	Data.Values = {};
	Data.Multi = false;
	Data.Default = {};

	local cache = {};
	local funcs = {};

	function Data:Update()
		for i,v in next , ScrollingFrame:GetChildren() do
			if v:IsA('Frame') then
				v:Destroy();
			end;
		end;

		for i,v in next , cache do
			v:Disconnect();
		end;

		table.clear(cache);
		table.clear(funcs);

		local x = 0;
		for i,v in next , Data.Values do
			local Frame = Instance.new("Frame")
			local Icon = Instance.new("TextLabel")
			local UIGradient = Instance.new("UIGradient")
			local Label = Instance.new("TextLabel")
			local UIGradient_2 = Instance.new("UIGradient")

			Frame:SetAttribute("txt",tostring(v));

			local size = TextService:GetTextSize(tostring(v),12,Enum.Font.Code,Vector2.new(math.huge,math.huge));

			if size.X > x then
				x = size.X
			end;

			Frame.Parent = ScrollingFrame
			Frame.BackgroundColor3 = Sealz.Theme.AccentColor
			Frame.BackgroundTransparency = 1.000
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.ClipsDescendants = true
			Frame.Size = UDim2.new(1, 0, 0, 20)
			Frame.ZIndex =ZIndex + 528

			Icon.Name = "Icon"
			Icon.Parent = Frame
			Icon.AnchorPoint = Vector2.new(0, 0.5)
			Icon.BackgroundColor3 = Sealz.Theme.AccentColor
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 0, 0.5, 0)
			Icon.Size = UDim2.new(0, 17, 0, 25)
			Icon.ZIndex = ZIndex + 529
			Icon.FontFace = Sealz.IconFont;
			Icon.Text = "check"
			Icon.TextColor3 = Sealz.Theme.AccentColor
			Icon.TextSize = 16.000
			Icon.TextTransparency = 1.000
			Icon.TextWrapped = true

			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
			UIGradient.Rotation = 90
			UIGradient.Parent = Icon

			Label.Name = "Label"
			Label.Parent = Frame
			Label.AnchorPoint = Vector2.new(0, 0.5)
			Label.BackgroundColor3 = Sealz.Theme.AccentColor
			Label.BackgroundTransparency = 1.000
			Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Label.BorderSizePixel = 0
			Label.Position = UDim2.new(0, 1, 0.5, 0)
			Label.Size = UDim2.new(1, -25, 0, 15)
			Label.ZIndex = ZIndex + 529
			Label.FontFace = Sealz.BoldFont
			Label.Text = tostring(v)
			Label.TextColor3 = Sealz.Theme.AccentColor
			Label.TextSize = 12.000
			Label.TextTransparency = 0.500
			Label.TextXAlignment = Enum.TextXAlignment.Left

			UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
			UIGradient_2.Rotation = 90
			UIGradient_2.Parent = Label

			local visual = function()
				local value = (
					v == Data.Default or
						(
							typeof(Data.Default) == "table" and
							(Data.Default[v] or table.find(Data.Default,v))
						)
				);

				Sealz:Tween(Label,Twnf,{
					TextTransparency = value and 0.25 or 0.5;
					Position = value and UDim2.new(0, 25, 0.5, 0) or UDim2.new(0, 1, 0.5, 0)
				});
				Sealz:Tween(Icon,Twnf,{
					TextTransparency = value and 0 or 1;
				});
			end;

			local load = function(value)
				if value then
					visual()
				else
					Sealz:Tween(Label,Twnf,{
						TextTransparency = 1;
					});
					Sealz:Tween(Icon,Twnf,{
						TextTransparency = 1;
					});
				end;
			end;

			table.insert(funcs,visual);

			if signal:Get() then
				visual()
			else
				load(false);
			end;

			if Data.Multi then
				local _,input = Sealz:AddInput(Frame,function()
					Data.Default[v] = not Data.Default[v];

					for i,v in next , funcs do
						v();
					end;

					if Data.Callback then
						Data.Callback(Data.Default)
					end
				end);

				table.insert(cache,input);
			else

				local _,input = Sealz:AddInput(Frame,function()
					Data.Default = v;

					for i,v in next , funcs do
						v();
					end;

					if Data.Callback then
						Data.Callback(Data.Default)
					end
				end);

				table.insert(cache,input);
			end;

			table.insert(cache,signal:Connect(load));
		end

		Data.HightestX = x + 55;
	end;

	return Data;
end;

function Sealz:FormatTable(value)
	if not value then return 'None'; end;

	local Out;

	if typeof(value) == 'table' then
		if #value > 0 then
			local x = {};

			for i,v in next , value do
				table.insert(x , tostring(v))
			end;

			Out = table.concat(x,' , ');

			if #x <= 0 then
				Out = "None"
			end
		else
			local x = {};

			for i,v in next , value do
				if v == true then
					table.insert(x , tostring(i));
				end			
			end;

			Out = table.concat(x,' , ');

			if #x <= 0 then
				Out = "None"
			end
		end;
	else
		Out = tostring(value);
	end;

	return Out;
end

function Sealz:ParseNumber(str)
	local out = string.gsub(tostring(str), '[^0-9.]', '')

	if tonumber(out) then
		return tonumber(out);
	end;

	return nil;
end

function Sealz:ResolvePosition(pos: UDim2)
	return UDim2.new(pos.X.Scale,pos.X.Offset,pos.Y.Scale,pos.Y.Offset + math.abs(Sealz.ScreenGui.AbsolutePosition.Y))
end;

function Sealz:KeyToString(key)
	if not key then
		return "None"
	end;

	if typeof(key) == "string" then
		return key
	end;
	return Sealz.InputRender[key] or key.Name
end;

local MouseInfo = {
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.MouseButton2] = true,
	[Enum.UserInputType.MouseButton3] = true,
};

Sealz.InputRender = {
	[Enum.UserInputType.MouseButton1] = "M1",
	[Enum.UserInputType.MouseButton2] = "M2",
	[Enum.UserInputType.MouseButton3] = "M3",

	[Enum.KeyCode.LeftAlt] = "LAlt",
	[Enum.KeyCode.RightAlt] = "RAlt",
	[Enum.KeyCode.LeftControl] = "LCtrl",
	[Enum.KeyCode.RightControl] = "RCtrl",
	[Enum.KeyCode.LeftSuper] = "SUPER",
	[Enum.KeyCode.RightSuper] = "SUPER",
	[Enum.KeyCode.LeftShift] = "LShift",
	[Enum.KeyCode.RightShift] = "Rshift",
};

local reback = {};

for i,v in next , Sealz.InputRender do
	reback[v] = i;
end;

Sealz.InputResolve = reback;

function Sealz:WaitForInput(blacklist)
	local input = nil;

	while not input do
		local Await = UserInputService.InputBegan:Wait();

		if Await.KeyCode ~= Enum.KeyCode.Unknown then
			if not blacklist[Await.KeyCode] and not table.find(blacklist , Await.KeyCode) then
				input = Await.KeyCode;
			end;
		elseif MouseInfo[Await.UserInputType] then
			if not blacklist[Await.UserInputType] and not table.find(blacklist , Await.UserInputType) then
				input = Await.UserInputType;
			end;
		end;
	end;

	return input;
end;

function Sealz:CreateBlockHandler(Frame: Frame, Signal: Signal)
	local Block = {}
	local Zindex = Frame.ZIndex;

	function Block:AddParagraph(content: string)
		local paragraph = {};

		local Paragraph = Instance.new("Frame")
		local TextLabel = Instance.new("TextLabel")

		Paragraph.Name = "Paragraph"
		Paragraph.Parent = Frame
		Paragraph.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Paragraph.BackgroundTransparency = 1.000
		Paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Paragraph.BorderSizePixel = 0
		Paragraph.Size = UDim2.new(1, 0, 0, 30)
		Paragraph.ZIndex = Zindex + 15

		TextLabel.Parent = Paragraph
		TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0, 10, 0, 10)
		TextLabel.Size = UDim2.new(1, -25, 1, -10)
		TextLabel.ZIndex = Zindex + 16
		TextLabel.FontFace = Sealz.BoldFont
		TextLabel.TextColor3 = Sealz.Theme.AccentColor
		TextLabel.TextSize = 13.000
		TextLabel.TextTransparency = 0.45
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.TextYAlignment = Enum.TextYAlignment.Top

		if content then
			TextLabel.Text = content
		end

		paragraph.Signal = Signal:Connect(function(value)
			Sealz:Tween(TextLabel,Twnf,{
				TextTransparency = value and 0.45 or 1;
			})
		end)

		function paragraph:SetText(text: string)
			TextLabel.Text = text;

			paragraph:Update()
		end;

		function paragraph:Update()
			local size = TextService:GetTextSize(TextLabel.Text,TextLabel.TextSize,Enum.Font.Code,Vector2.new(Frame.AbsoluteSize.X,math.huge));

			Sealz:Tween(Paragraph,Twnf,{
				Size = UDim2.new(1, 0, 0, size.Y + 15)
			})
		end

		paragraph:Update()

		return paragraph
	end;

	function Block:AddLabel(name: string)
		local LabelBlock = {};

		local LabelFrame = Instance.new("Frame")
		local TextLabel = Instance.new("TextLabel")
		local ListFrame = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")

		LabelFrame.Name = "LabelFrame"
		LabelFrame.Parent = Frame
		LabelFrame.BackgroundColor3 = Sealz.Theme.AccentColor
		LabelFrame.BackgroundTransparency = 1.000
		LabelFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LabelFrame.BorderSizePixel = 0
		LabelFrame.Size = UDim2.new(1, 0, 0, 30)
		LabelFrame.ZIndex = Zindex + 15


		TextLabel.Parent = LabelFrame
		TextLabel.BackgroundColor3 = Sealz.Theme.AccentColor
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0, 10, 0.5, 0)
		TextLabel.Size = UDim2.new(1, -25, 0, 25)
		TextLabel.ZIndex = Zindex + 16
		TextLabel.FontFace = Sealz.BoldFont
		TextLabel.AnchorPoint = Vector2.new(0,0.5)
		TextLabel.TextColor3 = Sealz.Theme.AccentColor
		TextLabel.TextSize = 13.000
		TextLabel.TextTransparency = 0.45
		TextLabel.Text = name;
		TextLabel.RichText = true;
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		ListFrame.Name = "ListFrame"
		ListFrame.Parent = LabelFrame
		ListFrame.AnchorPoint = Vector2.new(1, 0)
		ListFrame.BackgroundColor3 = Sealz.Theme.AccentColor
		ListFrame.BackgroundTransparency = 1.000
		ListFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ListFrame.BorderSizePixel = 0
		ListFrame.Position = UDim2.new(1, -10, 0, 4)
		ListFrame.Size = UDim2.new(0, 100, 0, 22)
		ListFrame.ZIndex = Zindex + 17

		UIListLayout.Parent = ListFrame
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 5)


		local Handler = Sealz:CreateInputHandler(ListFrame,Signal);

		LabelBlock.Root = LabelFrame;
		LabelBlock.Signal = Signal:Connect(function(value)
			if value and not Handler.Visible then
				return
			end;

			Sealz:Tween(TextLabel,Twnf,{
				TextTransparency = value and 0.45 or 1;
			})
		end)

		function Handler:Center()
			TextLabel.TextXAlignment = Enum.TextXAlignment.Center
		end;

		function Handler:SetColor(dbd)
			TextLabel.TextColor3 = dbd;
			if Handler.GlobalIcon then
				Handler.GlobalIcon.TextColor3 = dbd;
			end
		end;

		function Handler:Destroy()
			LabelFrame:Destroy();
			LabelBlock.Signal:Disconnect();

			if Handler.IconSignal then
				Handler.IconSignal:Disconnect();
			end;

			table.clear(Handler);
			Handler = nil;
		end;

		function Handler:Icon(name)
			if Handler.GlobalIcon then
				Handler.GlobalIcon.Text = name;
				return
			end;

			local Icon = Instance.new("TextLabel")

			Icon.Name = "Icon"
			Icon.Parent = LabelFrame
			Icon.AnchorPoint = Vector2.new(0, 0.5)
			Icon.BackgroundColor3 = Sealz.Theme.AccentColor
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 5, 0.5, 0)
			Icon.Size = UDim2.new(0, 25, 0, 25)
			Icon.ZIndex =  Zindex + 18
			Icon.FontFace = Sealz.IconFont
			Icon.Text = name or "chart-four-vertical-bars"
			Icon.TextColor3 = TextLabel.TextColor3 or Sealz.Theme.AccentColor
			Icon.TextSize = 16.000
			Icon.RichText = true;
			Icon.TextWrapped = true
			Handler.GlobalIcon = Icon;

			Handler.IconSignal = Signal:Connect(function(value)
				if value and not 	Handler.Visible then
					return
				end;

				Sealz:Tween(Icon,Twnf,{
					TextTransparency = value and 0 or 1;
				})
			end)

			TextLabel.Position = UDim2.new(0, 35, 0.5, 0)
			return Handler
		end;

		function Handler:SetText(label)
			TextLabel.Text = label;
		end;

		function Handler:Context(func)
			return func(Handler);
		end;

		Handler.Visible = true;

		function Handler:SetVisible(value)

			if Handler.Visible ~= value then
				Sealz:Tween(LabelFrame,Twnf,{
					Size = value and UDim2.new(1, 0, 0, 30) or UDim2.new(1, 0, 0, 0);
				});
			end;

			Handler.Visible = value;

			if value and not Signal:Get() then
				return
			end;


			Sealz:Tween(TextLabel,Twnf,{
				TextTransparency = value and 0.45 or 1;
			});

			if Handler.GlobalIcon then
				Sealz:Tween(Handler.GlobalIcon,Twnf,{
					TextTransparency = value and 0 or 1;
				})
			end;
		end;

		return Handler;
	end;

	function Block:AddButton(Content: string, IconStr: string , Callback: ()-> ())
		local ButtonFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local UIShadow = Instance.new("UIShadow")
		local TextLabel = Instance.new("TextLabel")
		local Icon = Instance.new("TextLabel")
		local Height = Instance.new("Frame")
		local Height2 = Instance.new("Frame")

		Height2.BackgroundTransparency = 1;
		Height2.Size = UDim2.fromOffset(0,5);
		Height2.Parent = Frame;


		ButtonFrame.Name = "ButtonFrame"
		ButtonFrame.Parent = Frame
		ButtonFrame.BackgroundColor3 = Sealz.Theme.Background
		ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonFrame.BorderSizePixel = 0
		ButtonFrame.Size = UDim2.new(1, -10, 0, 30)
		ButtonFrame.ZIndex = Zindex + 17

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = ButtonFrame

		UICorner.TopLeftRadius = UDim.new(0, 4)
		UICorner.TopRightRadius = UDim.new(0, 4)
		UICorner.BottomLeftRadius = UDim.new(0, 4)
		UICorner.BottomRightRadius = UDim.new(0, 4)
		UICorner.Parent = ButtonFrame

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.500
		UIShadow.Parent = ButtonFrame

		TextLabel.Parent = ButtonFrame
		TextLabel.AnchorPoint = Vector2.new(0, 0.5)
		TextLabel.BackgroundColor3 = Sealz.Theme.AccentColor
		TextLabel.BackgroundTransparency = 1.000
		TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.Position = UDim2.new(0, 30, 0.5, 0)
		TextLabel.Size = UDim2.new(1, -25, 0, 15)
		TextLabel.ZIndex = Zindex + 18
		TextLabel.FontFace = Sealz.BoldFont
		TextLabel.Text = Content
		TextLabel.TextColor3 = Sealz.Theme.AccentColor
		TextLabel.TextSize = 12.000
		TextLabel.TextTransparency = 0.500
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		Icon.Name = "Icon"
		Icon.Parent = ButtonFrame
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Sealz.Theme.AccentColor
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 5, 0.5, 0)
		Icon.Size = UDim2.new(0, 18, 0, 18)
		Icon.ZIndex = Zindex + 18
		Icon.FontFace = Sealz.IconFont
		Icon.Text = IconStr or "mouse-button-left"
		Icon.TextColor3 = Sealz.Theme.AccentColor
		Icon.TextSize = 12.000
		Icon.TextWrapped = true

		Signal:Connect(function(val)
			Sealz:Tween(ButtonFrame,Twnf,{
				BackgroundTransparency = val and 0 or 1
			})	

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = val and 0 or 1
			})

			Sealz:Tween(UIShadow,Twnf,{
				Transparency = val and 0.5 or 1
			})

			Sealz:Tween(TextLabel,Twnf,{
				TextTransparency = val and 0.5 or 1
			})

			Sealz:Tween(Icon,Twnf,{
				TextTransparency = val and 0 or 1
			})
		end);

		local bth = Sealz:AddInput(ButtonFrame,function()
			Callback();
		end)

		Height.BackgroundTransparency = 1;
		Height.Size = UDim2.fromOffset(0,5);
		Height.Parent = Frame;

		bth.MouseEnter:Connect(function()
			Sealz:Tween(ButtonFrame,Twnf,{
				BackgroundColor3 = Sealz.Theme.ItemBackground
			})
		end)

		bth.MouseLeave:Connect(function()
			Sealz:Tween(ButtonFrame,Twnf,{
				BackgroundColor3 = Sealz.Theme.Background
			})
		end)
	end;

	function Block:Separator()
		local Line = Instance.new("Frame")
		local Height = Instance.new("Frame")
		local Height2 = Instance.new("Frame")
		Height2.BackgroundTransparency = 1;
		Height2.Size = UDim2.fromOffset(0,2);
		Height2.Parent = Frame;

		Line.Name = "Line"
		Line.Parent = Frame
		Line.BackgroundColor3 = Sealz.Theme.Stroke
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BorderSizePixel = 0
		Line.Size = UDim2.new(1, -10, 0, 1)
		Line.ZIndex = Frame.ZIndex + 1;	
		Line.BackgroundTransparency = 0.1

		Height.BackgroundTransparency = 1;
		Height.Size = UDim2.fromOffset(0,2);
		Height.Parent = Frame;

	end

	return Block;
end;

function Sealz.new(arg)
	arg = Sealz:Format(arg,{
		Title = "Sealz",
		Description = "Lua Scripts",
		Keybind = "Insert",
		Size = UserInputService.TouchEnabled and Sealz.Size.Small or Sealz.Size.Default
	});

	if arg.Blur == nil then
		arg.Blur = true
	end

	local Window = {
		Signal = CreateSignal(true),
		Keybind = arg.Keybind,
		Size = arg.Size,
		Blur = arg.Blur
	};

	local OutlineFrame = Instance.new("Frame")
	local MainFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIShadow = Instance.new("UIShadow")
	local HeaderFrame = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local UIShadow_2 = Instance.new("UIShadow")
	local LineFrame = Instance.new("Frame")
	local WindowLabel = Instance.new("TextLabel")
	local WindowSecondLabel = Instance.new("TextLabel")
	local TabButtonContainer = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIShadow_3 = Instance.new("UIShadow")
	local UIGradient = Instance.new("UIGradient")
	local SelectionFrame = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local TabButtonListFrame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local UIStroke = Instance.new("UIStroke")
	OutlineFrame.Active = true
	local Shadow = Sealz:AddShadow(MainFrame);
	local Bast = arg.Blur and 0.075 or 0;

	Window.Signal:Connect(function(value)
		Shadow(value);

		Sealz:Tween(OutlineFrame,Twnf,{
			Size = value and Window.Size or UDim2.new(Window.Size.X.Scale,Window.Size.X.Offset - 40,Window.Size.Y.Scale,Window.Size.Y.Offset - 40)
		});

		Sealz:Tween(MainFrame,Twnf,{
			BackgroundTransparency = value and Bast or 1;

		});

		Sealz:Tween(HeaderFrame,Twnf,{
			BackgroundTransparency = value and 0 or 1;
		});

		Sealz:Tween(UIShadow_2,Twnf,{
			Transparency = value and 0.5 or 1;
		});

		Sealz:Tween(UIShadow_3,Twnf,{
			Transparency = value and 0.5 or 1;
		});

		Sealz:Tween(LineFrame,Twnf,{
			BackgroundTransparency = value and 0 or 1;
		});

		Sealz:Tween(WindowLabel,Twnf,{
			TextTransparency = value and 0 or 1;
		});

		Sealz:Tween(WindowSecondLabel,Twnf,{
			TextTransparency = value and 0.2 or 1;
		});

		Sealz:Tween(TabButtonContainer,Twnf,{
			BackgroundTransparency = value and 0 or 1;
		});

		Sealz:Tween(SelectionFrame,Twnf,{
			Transparency = value and 0.1 or 1;
		});

		Sealz:Tween(UIStroke,Twnf,{
			Transparency = value and 0 or 1;
		});
	end)


	OutlineFrame.Name = "OutlineFrame"
	OutlineFrame.Parent = Sealz.ScreenGui
	OutlineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	OutlineFrame.BackgroundColor3 = Sealz.Theme.ItemBackground
	OutlineFrame.BackgroundTransparency = 1.000
	OutlineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OutlineFrame.BorderSizePixel = 0
	OutlineFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	OutlineFrame.Size = Window.Size
	
	Sealz:OnShow(OutlineFrame , MainFrame)
	Sealz:AddDrag(HeaderFrame,OutlineFrame,0.2);

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = OutlineFrame
	MainFrame.AnchorPoint = Vector2.new(1, 0.5)
	MainFrame.BackgroundColor3 = Sealz.Theme.ItemBackground
	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.BackgroundTransparency = Bast
	MainFrame.ClipsDescendants = true
	MainFrame.Position = UDim2.new(1, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(1, 0, 1, 0)
	MainFrame.ZIndex = 3

	if arg.Blur then
		Sealz:AddBlurring(MainFrame,Window.Signal)
	end

	UICorner.Parent = MainFrame

	HeaderFrame.Name = "HeaderFrame"
	HeaderFrame.Parent = MainFrame
	HeaderFrame.BackgroundColor3 = Sealz.Theme.Background
	HeaderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderFrame.BorderSizePixel = 0
	HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
	HeaderFrame.ZIndex = 4

	UICorner_2.BottomLeftRadius = UDim.new(0, 0)
	UICorner_2.BottomRightRadius = UDim.new(0, 0)
	UICorner_2.Parent = HeaderFrame

	UIShadow_2.BlurRadius = UDim.new(0, 20)
	UIShadow_2.Transparency = 0.750
	UIShadow_2.Parent = HeaderFrame;

	LineFrame.Name = "LineFrame"
	LineFrame.Parent = HeaderFrame
	LineFrame.BackgroundColor3 = Sealz.Theme.Stroke
	LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame.BorderSizePixel = 0
	LineFrame.Position = UDim2.new(0, 0, 1, 0)
	LineFrame.Size = UDim2.new(1, 0, 0, 1)
	LineFrame.ZIndex = 5

	WindowLabel.Name = "WindowLabel"
	WindowLabel.Parent = HeaderFrame
	WindowLabel.BackgroundColor3 = Sealz.Theme.AccentColor
	WindowLabel.BackgroundTransparency = 1.000
	WindowLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowLabel.BorderSizePixel = 0
	WindowLabel.Position = UDim2.new(0, 10, 0, 7)
	WindowLabel.Size = UDim2.new(0, 200, 0, 15)
	WindowLabel.ZIndex = 5
	WindowLabel.FontFace = Sealz.MediumFont
	WindowLabel.Text = arg.Title
	WindowLabel.RichText = true;
	WindowLabel.TextColor3 = Sealz.Theme.AccentColor
	WindowLabel.TextSize = 14.000
	WindowLabel.TextXAlignment = Enum.TextXAlignment.Left

	WindowSecondLabel.Name = "WindowSecondLabel"
	WindowSecondLabel.Parent = HeaderFrame
	WindowSecondLabel.AnchorPoint = Vector2.new(0, 1)
	WindowSecondLabel.BackgroundColor3 = Sealz.Theme.AccentColor
	WindowSecondLabel.BackgroundTransparency = 1.000
	WindowSecondLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowSecondLabel.BorderSizePixel = 0
	WindowSecondLabel.Position = UDim2.new(0, 10, 1, -7)
	WindowSecondLabel.Size = UDim2.new(0, 200, 0, 11)
	WindowSecondLabel.ZIndex = 5
	WindowSecondLabel.FontFace = Sealz.MediumFont
	WindowSecondLabel.Text = arg.Description
	WindowSecondLabel.TextColor3 = Sealz.Theme.AccentColor
	WindowSecondLabel.TextSize = 11.000
	WindowSecondLabel.RichText = true;
	WindowSecondLabel.TextTransparency = 0.200
	WindowSecondLabel.TextXAlignment = Enum.TextXAlignment.Left

	TabButtonContainer.Name = "TabButtonContainer"
	TabButtonContainer.Parent = HeaderFrame
	TabButtonContainer.AnchorPoint = Vector2.new(1, 0.5)
	TabButtonContainer.BackgroundColor3 = Sealz.Theme.Stroke
	TabButtonContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabButtonContainer.BorderSizePixel = 0
	TabButtonContainer.ClipsDescendants = true
	TabButtonContainer.Position = UDim2.new(1, -10, 0.5, 0)
	TabButtonContainer.Size = UDim2.new(0, 200, 0, 25)
	TabButtonContainer.ZIndex = 6

	UICorner_3.TopLeftRadius = UDim.new(1, 0)
	UICorner_3.TopRightRadius = UDim.new(1, 0)
	UICorner_3.BottomLeftRadius = UDim.new(1, 0)
	UICorner_3.BottomRightRadius = UDim.new(1, 0)
	UICorner_3.Parent = TabButtonContainer

	UIShadow_3.BlurRadius = UDim.new(0, 20)
	UIShadow_3.Transparency = 0.750
	UIShadow_3.Parent = TabButtonContainer;

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(165, 165, 165))}
	UIGradient.Rotation = 90
	UIGradient.Parent = TabButtonContainer

	SelectionFrame.Name = "SelectionFrame"
	SelectionFrame.Parent = TabButtonContainer
	SelectionFrame.BackgroundColor3 = Sealz.Theme.AccentColor
	SelectionFrame.BackgroundTransparency = 0.100
	SelectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SelectionFrame.BorderSizePixel = 0
	SelectionFrame.Size = UDim2.new(0, 100, 0, 25)
	SelectionFrame.ZIndex = 6
	SelectionFrame.AnchorPoint = Vector2.new(0.5,0.5)

	UICorner_4.TopLeftRadius = UDim.new(1, 0)
	UICorner_4.TopRightRadius = UDim.new(1, 0)
	UICorner_4.BottomLeftRadius = UDim.new(1, 0)
	UICorner_4.BottomRightRadius = UDim.new(1, 0)
	UICorner_4.Parent = SelectionFrame

	TabButtonListFrame.Name = "TabButtonListFrame"
	TabButtonListFrame.Parent = TabButtonContainer
	TabButtonListFrame.BackgroundColor3 = Sealz.Theme.AccentColor
	TabButtonListFrame.BackgroundTransparency = 1.000
	TabButtonListFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabButtonListFrame.BorderSizePixel = 0
	TabButtonListFrame.Size = UDim2.new(1, 0, 1, 0)

	UIListLayout.Parent = TabButtonListFrame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	UIStroke.Color = Sealz.Theme.Stroke
	UIStroke.Parent = MainFrame

	Window.CurrentTab = nil;
	Window.Tabs = {};

	local TabFrameContainer = Instance.new("Frame")

	TabFrameContainer.Name = "TabFrameContainer"
	TabFrameContainer.Parent = MainFrame
	TabFrameContainer.AnchorPoint = Vector2.new(0.5, 0)
	TabFrameContainer.BackgroundColor3 = Sealz.Theme.AccentColor
	TabFrameContainer.BackgroundTransparency = 1.000
	TabFrameContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabFrameContainer.BorderSizePixel = 0
	TabFrameContainer.ClipsDescendants = true
	TabFrameContainer.Position = UDim2.new(0.5, 0, 0, 47)
	TabFrameContainer.Size = UDim2.new(1, -10, 1, -53)
	TabFrameContainer.ZIndex = 6

	Window.Loop = task.defer(function()
		while true do task.wait(0.1)
			TabButtonContainer.Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, 25)

			if Window.CurrentTab then
				local Tab = Window.Tabs[Window.CurrentTab];
				if Tab then
					local rootpos = Tab.Root.AbsolutePosition;
					local rootsize = Tab.Root.AbsoluteSize;

					local posize = math.abs(TabButtonContainer.AbsolutePosition.X - rootpos.X) + (rootsize.X / 2);

					Sealz:Tween(SelectionFrame,Twnf,{
						Position = UDim2.new(0,math.floor(posize),0.5,0);
						Size = UDim2.fromOffset(rootsize.X,25)
					})

				end;
			end
		end;
	end);

	function Window:AddWindow(args)
		args = Sealz:Format(args,{
			ZIndex = 600,
		});

		local window = Sealz:CreateFloatWindow(args.ZIndex,true);

		Sealz:AddDrag(window.Root,window.Root,0.1,Window.Signal);
		window:SetPosition(UDim2.fromOffset(100,100 + math.random(50,150)))

		Window.Signal:Connect(function(v)
			window.Root.Active = v;
		end)

		if args.Flag or args.Id then
			Sealz.Flags[args.Flag or args.Id] = window;
		end;

		return window;
	end;
	
	function Window:AddExtendTab(args)
		args = args or "MENU";

		local Tab = {};
		local TabId = #Window.Tabs + 1;

		Tab.TabId = TabId;
		Tab.Signal = CreateSignal(not Window.CurrentTab);

		local Frame = Instance.new("Frame")
		local TextButton = Instance.new("TextButton")

		Tab.Root = Frame;

		Frame.Parent = TabButtonListFrame;
		Frame.BackgroundColor3 = Sealz.Theme.AccentColor
		Frame.BackgroundTransparency = 1.000
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(0, 100, 0, 25)
		Frame.ZIndex = 8

		TextButton.Parent = Frame
		TextButton.BackgroundColor3 = Sealz.Theme.AccentColor
		TextButton.BackgroundTransparency = 1.000
		TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextButton.BorderSizePixel = 0
		TextButton.Size = UDim2.new(1, 0, 1, 0)
		TextButton.ZIndex = 8
		TextButton.FontFace = Sealz.BoldFont;
		TextButton.Text = args
		TextButton.TextColor3 = Sealz.Theme.AccentColor
		TextButton.TextSize = 14.000
		TextButton.RichText = true;
		
		-- Gui to Lua
		-- Version: 3.5

		-- Instances:

		local TabHeadFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIShadow = Instance.new("UIShadow")
		local ButtonContainer = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIShadow_2 = Instance.new("UIShadow")
		local UIGradient = Instance.new("UIGradient")
		local SelectionFrame = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local TabButtonListFrame = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local UIStroke = Instance.new("UIStroke")
		
		local updparent = function()
			TabHeadFrame.Visible = math.abs(TextButton.TextColor.Color.B - Sealz.Theme.Black.B) <= 0.5;

			if TabHeadFrame.Visible then	
				TabHeadFrame.Parent = TabFrameContainer
			else
				TabHeadFrame.Parent = nil
			end;
		end;
		
		TextButton:GetPropertyChangedSignal("TextColor3"):Connect(updparent);
		task.delay(0.1,updparent)
		
		--Properties:

		TabHeadFrame.Name = "TabHeadFrame"
		TabHeadFrame.Parent = TabFrameContainer
		TabHeadFrame.AnchorPoint = Vector2.new(0.5, 0)
		TabHeadFrame.BackgroundColor3 = Sealz.Theme.Background
		TabHeadFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabHeadFrame.BorderSizePixel = 0
		TabHeadFrame.Position = UDim2.new(0.5, 0, 0, 1)
		TabHeadFrame.Size = UDim2.new(1, -5, 0, 35)
		TabHeadFrame.ZIndex = 9
		TabHeadFrame.Visible  = Tab.Signal:Get()

		UICorner.TopLeftRadius = UDim.new(0, 6)
		UICorner.TopRightRadius = UDim.new(0, 6)
		UICorner.BottomLeftRadius = UDim.new(0, 6)
		UICorner.BottomRightRadius = UDim.new(0, 6)
		UICorner.Parent = TabHeadFrame

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.750
		UIShadow.Parent = TabHeadFrame

		ButtonContainer.Name = "ButtonContainer"
		ButtonContainer.Parent = TabHeadFrame
		ButtonContainer.AnchorPoint = Vector2.new(0, 0.5)
		ButtonContainer.BackgroundColor3 = Sealz.Theme.Stroke
		ButtonContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonContainer.BorderSizePixel = 0
		ButtonContainer.ClipsDescendants = true
		ButtonContainer.Position = UDim2.new(0, 10, 0.5, 0)
		ButtonContainer.Size = UDim2.new(0, 200, 0, 25)
		ButtonContainer.ZIndex = 11

		UICorner_2.TopLeftRadius = UDim.new(1, 0)
		UICorner_2.TopRightRadius = UDim.new(1, 0)
		UICorner_2.BottomLeftRadius = UDim.new(1, 0)
		UICorner_2.BottomRightRadius = UDim.new(1, 0)
		UICorner_2.Parent = ButtonContainer

		UIShadow_2.BlurRadius = UDim.new(0, 20)
		UIShadow_2.Transparency = 0.750
		UIShadow_2.Parent = ButtonContainer

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(165, 165, 165))}
		UIGradient.Rotation = 90
		UIGradient.Parent = ButtonContainer

		SelectionFrame.Name = "SelectionFrame"
		SelectionFrame.Parent = ButtonContainer
		SelectionFrame.BackgroundColor3 = Sealz.Theme.AccentColor
		SelectionFrame.BackgroundTransparency = 0.100
		SelectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SelectionFrame.BorderSizePixel = 0
		SelectionFrame.Position = UDim2.new(0, 100, 0, 0)
		SelectionFrame.Size = UDim2.new(0, 100, 0, 25)
		SelectionFrame.ZIndex = 11
		SelectionFrame.AnchorPoint = Vector2.new(0.5,0.5);
		
		UICorner_3.TopLeftRadius = UDim.new(1, 0)
		UICorner_3.TopRightRadius = UDim.new(1, 0)
		UICorner_3.BottomLeftRadius = UDim.new(1, 0)
		UICorner_3.BottomRightRadius = UDim.new(1, 0)
		UICorner_3.Parent = SelectionFrame

		TabButtonListFrame.Name = "TabButtonListFrame"
		TabButtonListFrame.Parent = ButtonContainer
		TabButtonListFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabButtonListFrame.BackgroundTransparency = 1.000
		TabButtonListFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButtonListFrame.BorderSizePixel = 0
		TabButtonListFrame.Size = UDim2.new(1, 0, 1, 0)
		TabButtonListFrame.ZIndex = 11

		UIListLayout.Parent = TabButtonListFrame
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = TabHeadFrame
		
		local size = Sealz:GetTextSize(TextButton);
		Frame.Size = UDim2.new(0, size.X + 35, 0, 25);
		
		local OnVisible = function(value)
			Sealz:Tween(TextButton,Twnf,{
				TextTransparency = value and 0 or 1
			});

			Sealz:Tween(TabHeadFrame,Twnf,{
				BackgroundTransparency = value and 0 or 1
			});

			Sealz:Tween(UIShadow,Twnf,{
				Transparency = value and 0.75 or 1
			});

			Sealz:Tween(ButtonContainer,Twnf,{
				BackgroundTransparency = value and 0 or 1
			});

			Sealz:Tween(UIShadow_2,Twnf,{
				Transparency = value and 0.75 or 1
			});

			Sealz:Tween(SelectionFrame,Twnf,{
				BackgroundTransparency = value and 0.1 or 1
			});

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = value and 0 or 1
			});
		end
		
		Window.Signal:Connect(function(value)
			if not value then
				Tab.Signal:Fire(false)
			elseif Window.CurrentTab == TabId then
				
				Tab.Signal:Fire(true)

			end;
			
			OnVisible(value)
		end);

		local OnReload = function(value)
			Sealz:Tween(TextButton,Twnf,{
				TextColor3 = (Window.CurrentTab == TabId and Sealz.Theme.Black) or Sealz.Theme.AccentColor
			})
			
			Sealz:Tween(TabHeadFrame,Twnf,{
				BackgroundTransparency = value and 0 or 1
			});
			
			Sealz:Tween(UIShadow,Twnf,{
				Transparency = value and 0.75 or 1
			});

			Sealz:Tween(ButtonContainer,Twnf,{
				BackgroundTransparency = value and 0 or 1
			});

			Sealz:Tween(UIShadow_2,Twnf,{
				Transparency = value and 0.75 or 1
			});

			Sealz:Tween(SelectionFrame,Twnf,{
				BackgroundTransparency = value and 0.1 or 1
			});

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = value and 0 or 1
			});
			
			if value then
				Sealz:Tween(TabHeadFrame,Twnf,{
					Position = UDim2.new(0.5, 0, 0, 1)
				})
			else
				if Window.CurrentTab > TabId then
					Sealz:Tween(TabHeadFrame,Twnf,{
						Position = UDim2.new(0.4, 0, 0, 1)
					})
				else
					Sealz:Tween(TabHeadFrame,Twnf,{
						Position = UDim2.new(0.6, 0, 0, 1)
					})
				end;
			end;
		end;
		
		Tab.Loop = task.defer(function()
			while true do task.wait(0.1)
				ButtonContainer.Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 0, 25)
				
				if Tab.InnerCurrectSelected then
					local TabObj = Tab.InnerItems[Tab.InnerCurrectSelected];
					if TabObj then
						local rootpos = TabObj.Root.AbsolutePosition;
						local rootsize = TabObj.Root.AbsoluteSize;

						local posize = math.abs(ButtonContainer.AbsolutePosition.X - rootpos.X) + (rootsize.X / 2);

						Sealz:Tween(SelectionFrame,Twnf,{
							Position = UDim2.new(0,math.floor(posize),0.5,0);
							Size = UDim2.fromOffset(rootsize.X,25)
						})

					end;
				end
			end;
		end);

		Tab.InnerCurrectSelected = nil;
		Tab.InnerItems = {};
		
		function Tab:Add(name: string)
			local TabMain = {};
			local TabId2 = #Tab.InnerItems + 1;

			TabMain.TabId = TabId2;
			TabMain.Signal = CreateSignal(not Tab.InnerCurrectSelected);
			
			local Frame = Instance.new("Frame")
			local TextButton = Instance.new("TextButton")

			TabMain.Root = Frame;

			Frame.Parent = TabButtonListFrame;
			Frame.BackgroundColor3 = Sealz.Theme.AccentColor
			Frame.BackgroundTransparency = 1.000
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Size = UDim2.new(0, 100, 0, 25)
			Frame.ZIndex = 18
			
			TextButton.Parent = Frame
			TextButton.BackgroundColor3 = Sealz.Theme.AccentColor
			TextButton.BackgroundTransparency = 1.000
			TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextButton.BorderSizePixel = 0
			TextButton.Size = UDim2.new(1, 0, 1, 0)
			TextButton.ZIndex = 19
			TextButton.FontFace = Sealz.BoldFont;
			TextButton.Text = tostring(name)
			TextButton.TextColor3 = TabMain.Signal:Get() and Sealz.Theme.Black or Sealz.Theme.AccentColor;
			TextButton.TextSize = 14.000
			TextButton.RichText = true;

			local TabContainer = Instance.new("Frame")
			local UIListLayout = Instance.new("UIListLayout")
			
			local UpdateParent = function(force)
				TabContainer.Visible = force or (math.abs(TextButton.TextColor.Color.B - Sealz.Theme.Black.B) <= 0.5);
				
				if TabContainer.Visible and Tab.Signal:Get() then
					TabContainer.Parent = TabFrameContainer
				else
					TabContainer.Parent = nil
				end;
			end;
			
			TabContainer.Name = "TabContainer"
			TabContainer.Parent = nil
			TabContainer.AnchorPoint = Vector2.new(0.5, 0.5)
			TabContainer.BackgroundColor3 = Sealz.Theme.Background
			TabContainer.BackgroundTransparency = 1.000
			TabContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TabContainer.BorderSizePixel = 0
			TabContainer.Position = UDim2.new(0.5, 0, 0.5, 20)
			TabContainer.Size = UDim2.new(1, -5, 1, -45)
			TabContainer.ZIndex = 19
			TabContainer.Visible = TabMain.Signal:Get() and Tab.Signal:Get()
			
			TextButton:GetPropertyChangedSignal("TextColor3"):Connect(UpdateParent);
			
			task.delay(0.1,UpdateParent);

			UIListLayout.Parent = TabContainer
			UIListLayout.FillDirection = Enum.FillDirection.Horizontal
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 10)
			UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill;

			local size = Sealz:GetTextSize(TextButton);
			Frame.Size = UDim2.new(0, size.X + 35, 0, 25);
			
			local OnVisible = function(value)
				Sealz:Tween(TextButton,Twnf,{
					TextTransparency = (value and 0) or 1
				})
			end;
			
			Tab.Signal:Connect(function(value)
				if not value then
					TabMain.Signal:Fire(false)

				elseif Tab.InnerCurrectSelected == TabId2 and Window.CurrentTab == TabId then
					TabMain.Signal:Fire(true)
					print(Window.CurrentTab == TabId)
					UpdateParent(true)
				end;

				OnVisible(value)
			end);
			
			OnVisible(Tab.Signal:Get());
			
			local OnReload = function(value)
				Sealz:Tween(TextButton,Twnf,{
					TextColor3 = (value and Sealz.Theme.Black) or Sealz.Theme.AccentColor
				})

				if value then
					Sealz:Tween(TabContainer,Twnf,{
						Position = UDim2.new(0.5, 0, 0.5, 20)
					})
				else
					if Tab.InnerCurrectSelected > TabId2 then
						Sealz:Tween(TabContainer,Twnf,{
							Position = UDim2.new(0.4, 0, 0.5, 20)
						})
					else
						Sealz:Tween(TabContainer,Twnf,{
							Position = UDim2.new(0.6, 0, 0.5, 20)
						})
					end;
				end;
			end;
		
			TextButton.Activated:Connect(function()
				Tab.InnerCurrectSelected = TabId2;

				for i,v in next , Tab.InnerItems do
					if v.TabId == TabId2 then
						v.Signal:Fire(true);
					else
						v.Signal:Fire(false);
					end;
				end
			end);
			
			OnReload(TabMain.Signal:Get());
			TabMain.Signal:Connect(OnReload);
			
			function TabMain:AddMenu(Increase)
				local Menu = {}
				local ScrollingFrame = Instance.new("ScrollingFrame")
				local UIListLayout = Instance.new("UIListLayout")
				
				ScrollingFrame.Parent = TabContainer
				ScrollingFrame.Active = true
				ScrollingFrame.BackgroundColor3 = Sealz.Theme.AccentColor
				ScrollingFrame.BackgroundTransparency = 1.000
				ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ScrollingFrame.BorderSizePixel = 0
				ScrollingFrame.ClipsDescendants = false
				
				if Increase == nil or typeof(Increase) == "number" then
					ScrollingFrame.Size = UDim2.new(0, 0 + (Increase or 0), 1, 0)
				elseif Increase == true then -- auto
					UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
						ScrollingFrame.Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 1, 0)
					end)
				end
				
				
				ScrollingFrame.ZIndex = 10
				ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
				ScrollingFrame.ScrollBarThickness = 0
				ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;

				UIListLayout.Parent = ScrollingFrame
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.Padding = UDim.new(0, 10)

			

				Window.Signal:Connect(function(value)
					if not value then
						Tab.Signal:Fire(false)
					elseif Window.CurrentTab == TabId then
						Tab.Signal:Fire(true)
					end;
				end);

				local Menu2 = Sealz:CreateSectionHandler(ScrollingFrame,TabMain.Signal);
				Menu2.Tbl = Menu;
				function Menu2:SetSize(Size)
					Sealz:Tween(ScrollingFrame,Twnf,{
						Size = UDim2.new(0, 0 + (Size or 0), 1, 0)
					})
				end;
				function Menu2:Context(f)
					return f(Menu2)
				end;
				
				return Menu2;
			end;
			
			if TabMain.Signal:Get() then
				Tab.InnerCurrectSelected = TabId2;
			else
				TabContainer.Visible = false;
			end;
			
			table.insert(Tab.InnerItems,TabMain);
			
			return TabMain
		end;
		
		
		TextButton.Activated:Connect(function()
			Window.CurrentTab = TabId;

			for i,v in next , Window.Tabs do
				if v.TabId == TabId then
					v.Signal:Fire(true);
				else
					v.Signal:Fire(false);
				end;
			end
		end);

		if Tab.Signal:Get() then
			Window.CurrentTab = TabId;
		else

			TabHeadFrame.Visible = false;
		end;
		
		OnReload(Tab.Signal:Get());
		Tab.Signal:Connect(OnReload);

		table.insert(Window.Tabs,Tab);

		return Tab;
	end;
	
	function Window:AddTab(args)
		args = args or "MENU";

		local Tab = {};
		local TabId = #Window.Tabs + 1;

		Tab.TabId = TabId;
		Tab.Signal = CreateSignal(not Window.CurrentTab);

		local Frame = Instance.new("Frame")
		local TextButton = Instance.new("TextButton")

		Tab.Root = Frame;

		Frame.Parent = TabButtonListFrame;
		Frame.BackgroundColor3 = Sealz.Theme.AccentColor
		Frame.BackgroundTransparency = 1.000
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(0, 100, 0, 25)
		Frame.ZIndex = 8

		TextButton.Parent = Frame
		TextButton.BackgroundColor3 = Sealz.Theme.AccentColor
		TextButton.BackgroundTransparency = 1.000
		TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextButton.BorderSizePixel = 0
		TextButton.Size = UDim2.new(1, 0, 1, 0)
		TextButton.ZIndex = 8
		TextButton.FontFace = Sealz.BoldFont;
		TextButton.Text = args
		TextButton.TextColor3 = Sealz.Theme.AccentColor
		TextButton.TextSize = 14.000
		TextButton.RichText = true;

		local TabContainer = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		
		local upd = function()
			TabContainer.Visible = math.abs(TextButton.TextColor.Color.B - Sealz.Theme.Black.B) <= 0.5;

			if TabContainer.Visible then	
				TabContainer.Parent = TabFrameContainer
			else
				TabContainer.Parent = nil
			end;
		end;
		
		TextButton:GetPropertyChangedSignal("TextColor3"):Connect(upd);
		
		task.delay(0.1,upd)
		
		TabContainer.Name = "TabContainer"
		TabContainer.Parent = TabFrameContainer
		TabContainer.AnchorPoint = Vector2.new(0.5, 0.5)
		TabContainer.BackgroundColor3 = Sealz.Theme.Background
		TabContainer.BackgroundTransparency = 1.000
		TabContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabContainer.BorderSizePixel = 0
		TabContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabContainer.Size = UDim2.new(1, -5, 1, -5)
		TabContainer.ZIndex = 9
		
		UIListLayout.Parent = TabContainer
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 10)
		UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill;

		local size = Sealz:GetTextSize(TextButton);
		Frame.Size = UDim2.new(0, size.X + 35, 0, 25);

		Window.Signal:Connect(function(value)
			Sealz:Tween(TextButton,Twnf,{
				TextTransparency = value and 0 or 1
			});
		end);

		local OnReload = function(value)
			Sealz:Tween(TextButton,Twnf,{
				TextColor3 = value and Sealz.Theme.Black or Sealz.Theme.AccentColor
			})

			if value then
				Sealz:Tween(TabContainer,Twnf,{
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})
			else
				if Window.CurrentTab > TabId then
					Sealz:Tween(TabContainer,Twnf,{
						Position = UDim2.new(0.4, 0, 0.5, 0)
					})
				else
					Sealz:Tween(TabContainer,Twnf,{
						Position = UDim2.new(0.6, 0, 0.5, 0)
					})
				end;
			end;
		end;

		TextButton.Activated:Connect(function()
			Window.CurrentTab = TabId;

			for i,v in next , Window.Tabs do
				if v.TabId == TabId then
					v.Signal:Fire(true);
				else
					v.Signal:Fire(false);
				end;
			end
		end);

		if Tab.Signal:Get() then
			Window.CurrentTab = TabId;
		else
			TabContainer.Visible = false;
		end;

		function Tab:AddMenu(Increase)
			local Menu = {}
			local ScrollingFrame = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")

			ScrollingFrame.Parent = TabContainer
			ScrollingFrame.Active = true
			ScrollingFrame.BackgroundColor3 = Sealz.Theme.AccentColor
			ScrollingFrame.BackgroundTransparency = 1.000
			ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			ScrollingFrame.BorderSizePixel = 0
			ScrollingFrame.ClipsDescendants = false
			
			if Increase == nil or typeof(Increase) == "number" then
				ScrollingFrame.Size = UDim2.new(0, 0 + (Increase or 0), 1, 0)
			elseif Increase == true then -- auto
				UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
					ScrollingFrame.Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X, 1, 0)
				end)
			end
			
			ScrollingFrame.ZIndex = 10
			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			ScrollingFrame.ScrollBarThickness = 0
			ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;

			UIListLayout.Parent = ScrollingFrame
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 10)

			

			

			Window.Signal:Connect(function(value)
				if not value then
					Tab.Signal:Fire(false)
				elseif Window.CurrentTab == TabId then
					Tab.Signal:Fire(true)
				end;
			end);
			
			local Menu2 = Sealz:CreateSectionHandler(ScrollingFrame,Tab.Signal);
			Menu2.Tbl = Menu;
			function Menu2:SetSize(Size)
				Sealz:Tween(ScrollingFrame,Twnf,{
					Size = UDim2.new(0, 0 + (Size or 0), 1, 0)
				})
			end;
			function Menu2:Context(f)
				return f(Menu2)
			end;
			return Menu2;
		end;

		OnReload(Tab.Signal:Get());
		Tab.Signal:Connect(OnReload);

		table.insert(Window.Tabs,Tab);

		return Tab;
	end;

	function Window:SetKeybind(k)
		Window.Keybind = k;
	end;

	function Window:SetSize(k)
		Window.Size = k;

		Sealz:Tween(OutlineFrame,TweenInfo.new(0.6,Enum.EasingStyle.Quint),{
			Size = k
		});
	end;

	function Window:Toggle()
		Window.Signal:Fire(not Window.Signal:Get());
	end;

	function Window:ForceCenter()
		Sealz:Tween(OutlineFrame,Twnf,{
			Position = UDim2.fromScale(0.5,0.5)
		});
	end

	if UserInputService.TouchEnabled then
		local MobileFrame = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local UIShadow = Instance.new("UIShadow")
		local Icon = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")

		MobileFrame.Name = "MobileFrame"
		MobileFrame.Parent = Sealz.ScreenGui
		MobileFrame.BackgroundColor3 = Sealz.Theme.ItemBackground
		MobileFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MobileFrame.BorderSizePixel = 0
		MobileFrame.Position = UDim2.new(0, 15, 0, 65)
		MobileFrame.Size = UDim2.new(0, 30, 0, 30)
		MobileFrame.ZIndex = 17

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = MobileFrame

		UICorner.TopLeftRadius = UDim.new(0, 4)
		UICorner.TopRightRadius = UDim.new(0, 4)
		UICorner.BottomLeftRadius = UDim.new(0, 4)
		UICorner.BottomRightRadius = UDim.new(0, 4)
		UICorner.Parent = MobileFrame

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.500
		UIShadow.Parent = MobileFrame

		Icon.Name = "Icon"
		Icon.Parent = MobileFrame
		Icon.BackgroundColor3 = Sealz.Theme.AccentColor
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Size = UDim2.new(1, 0, 1, 0)
		Icon.ZIndex = 18
		Icon.FontFace = Sealz.IconFont
		Icon.Text = "square-code"
		Icon.TextColor3 = Sealz.Theme.AccentColor
		Icon.TextSize = 16.000
		Icon.TextWrapped = true

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
		UIGradient.Rotation = 90
		UIGradient.Parent = Icon

		Sealz:AddInput(MobileFrame,function()
			Window:Toggle()
		end);
	end

	Window.InputSignal = UserInputService.InputBegan:Connect(function(Input,ProcessEvent)
		if Sealz:IsPress(Input , Window.Keybind) and not ProcessEvent then
			Window.Signal:Fire(not Window.Signal:Get());
		end;
	end);

	return Window;
end;

function Sealz:CreateSectionHandler(Frame , Signal)
	local Menu = {};
	
	function Menu:AddConfig(path: string)
		if not getgenv().isfolder(path) then
			getgenv().makefolder(path);
		end;

		local Config_directory = path..'/Configs';
		local cache = path..'/cfg';

		if not getgenv().isfolder(Config_directory) then
			getgenv().makefolder(Config_directory);
		end;

		local Section = Menu:AddSection({
			Title = "Configuration",
			Icon = "gear"
		});

		local ListConfig = function()
			local d = {};

			for i,v in next , getgenv().listfiles(Config_directory) do
				local name = v:match("([^\\/]+)$");

				table.insert(d,name)
			end;

			return d;
		end;

		local Current = ListConfig();
		local SelectedConfig , NameConfig = "","";

		local GetCurrentValue = function()
			local d = {};

			for i,v in next , Sealz.Flags do
				local data = v:GetValue();

				if typeof(data) == "Color3" then
					d[i] = {
						_t = "Color3",
						_v = {
							r = data.R,
							g = data.G,
							b = data.B
						}
					};
				elseif typeof(data) == "EnumItem" then
					local EnumItem = tostring(data.EnumType);
					local EnumValue = tostring(data.Name);

					d[i] = {
						_t = "Enum",
						_v = {
							i = EnumItem,
							v = EnumValue
						}
					};
				elseif typeof(data) == "UDim2" then
					d[i] = {
						_t = "UDim2",
						_v = {
							xs = data.X.Scale,
							xo = data.X.Offset,

							ys = data.Y.Scale,
							yo = data.Y.Offset
						}
					};
				else
					d[i] = {
						_t = typeof(data),
						_v = data
					}
				end;
			end;

			return d;
		end;

		local format_todata = function(data)
			if data._t == "Color3" then
				return Color3.new(data._v.r,data._v.g,data._v.b);
			elseif data._t == "Enum" then
				return Enum[SelectedConfig._v.i][SelectedConfig._v.v];
			elseif data._t == "UDim2" then
				return UDim2.new(data._v.xs,data._v.xo,data._v.ys,data._v.yo);
			else
				return data._v;
			end;
		end

		local list = Section:AddLabel("Config List"):AddDropdown({
			Default = Current[1] or "Default",
			Values = Current,
			Callback = function(v: string)
				SelectedConfig = v;
			end,
		});

		task.spawn(function()
			while true do task.wait(5)
				local data = ListConfig();

				list:SetValues(data);

				task.wait();
			end;
		end)

		local load_from_data = function(content)
			local b64 = Sealz.Base64.Decode(content);
			local decode = HttpService:JSONDecode(b64);

			for i,v in next , decode do
				if Sealz.Flags[i] then
					local format = format_todata(v);

					task.spawn(function()
						Sealz.Flags[i]:SetValue(format);
					end)
				end;
			end;
		end;

		Section:AddButton("Load","arrow-right-to-portrait-rectangle",function()
			if SelectedConfig:byte() and isfile(Config_directory..'/'..SelectedConfig) then
				local content = getgenv().readfile(Config_directory..'/'..SelectedConfig);
				load_from_data(content)

				getgenv().writefile(cache,SelectedConfig);
			end;
		end)

		Section:AddButton("Save","floppy-disk",function()
			if SelectedConfig:byte() and isfile(Config_directory..'/'..SelectedConfig) then
				local current = GetCurrentValue();

				current.__info = {
					timestamp = tick(),
					name = NameConfig,
					overwrite = true,
				};

				local Encode = HttpService:JSONEncode(current);

				getgenv().writefile(Config_directory..'/'..SelectedConfig , Sealz.Base64.Encode(Encode))
			end
		end)

		Section:Separator();

		Section:AddLabel("Name"):AddInput({
			Placeholder = "Config name ...",
			Callback = function(v: string)
				NameConfig = v;
			end,
		})

		Section:AddButton("Create","folder",function()
			if not NameConfig:byte() then
				return;
			end;

			local current = GetCurrentValue();

			current.__info = {
				timestamp = tick(),
				name = NameConfig
			};

			local Encode = HttpService:JSONEncode(current);

			getgenv().writefile(cache,NameConfig);

			getgenv().writefile(Config_directory..'/'..NameConfig , Sealz.Base64.Encode(Encode))
		end);

		pcall(function()
			task.delay(2.5,function()
				if getgenv().isfile(cache) then
					local data = getgenv().readfile(cache);

					local pth = Config_directory..'/'..data;

					if getgenv().isfile(pth) then
						load_from_data(getgenv().readfile(pth));
					end;

					list:SetValue(data);

					SelectedConfig = data;
				end
			end);
		end)
	end;

	function Menu:AddSection(arg: {Title: string, Icon: string})
		arg = Sealz:Format(arg,{
			Title = "Section",
			Icon = ""
		});

		local Sect = {};

		local SectionFrame = Instance.new("Frame")
		local HeadFrame = Instance.new("Frame")
		local Label = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")
		local Icon = Instance.new("TextLabel")
		local UIGradient_2 = Instance.new("UIGradient")
		local Line = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UIShadow = Instance.new("UIShadow")
		local UICorner = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")

		SectionFrame.Name = "SectionFrame"
		SectionFrame.Parent = Frame
		SectionFrame.BackgroundColor3 = Sealz.Theme.Background
		SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SectionFrame.BorderSizePixel = 0
		SectionFrame.ClipsDescendants = true
		SectionFrame.Size = UDim2.new(1, 0, 0, 0)
		SectionFrame.ZIndex = Frame.ZIndex + 8
		SectionFrame.BackgroundTransparency = 0.05

		HeadFrame.Name = "HeadFrame"
		HeadFrame.Parent = SectionFrame
		HeadFrame.BackgroundColor3 = Sealz.Theme.AccentColor
		HeadFrame.BackgroundTransparency = 1.000
		HeadFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		HeadFrame.BorderSizePixel = 0
		HeadFrame.Size = UDim2.new(1, 0, 0, 30)
		HeadFrame.ZIndex = Frame.ZIndex + 15

		Label.RichText = true;
		Label.Name = "Label"
		Label.Parent = HeadFrame
		Label.AnchorPoint = Vector2.new(0, 0.5)
		Label.BackgroundColor3 = Sealz.Theme.AccentColor
		Label.BackgroundTransparency = 1.000
		Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Label.BorderSizePixel = 0
		Label.Position = UDim2.new(0, 15, 0.5, 0)
		Label.Size = UDim2.new(1, -25, 0, 25)
		Label.ZIndex = Frame.ZIndex + 16
		Label.FontFace = Sealz.BoldFont
		Label.Text = arg.Title
		Label.TextColor3 = Sealz.Theme.AccentColor
		Label.TextSize = 16.000
		Label.TextXAlignment = Enum.TextXAlignment.Left

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
		UIGradient.Rotation = 90
		UIGradient.Parent = Label

		Icon.Name = "Icon"
		Icon.Parent = HeadFrame
		Icon.AnchorPoint = Vector2.new(1, 0.5)
		Icon.BackgroundColor3 = Sealz.Theme.AccentColor
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(1, -10, 0.5, 0)
		Icon.Size = UDim2.new(0, 25, 0, 25)
		Icon.ZIndex = Frame.ZIndex + 16
		Icon.FontFace = Sealz.IconFont
		Icon.Text = arg.Icon
		Icon.TextColor3 = Sealz.Theme.AccentColor
		Icon.TextSize = 16.000
		Icon.RichText = true;
		Icon.TextWrapped = true

		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
		UIGradient_2.Rotation = 90
		UIGradient_2.Parent = Icon

		Line.Name = "Line"
		Line.Parent = SectionFrame
		Line.BackgroundColor3 = Sealz.Theme.Stroke
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BorderSizePixel = 0
		Line.Size = UDim2.new(1, -10, 0, 1)
		Line.ZIndex = Frame.ZIndex + 20

		UIStroke.Color = Sealz.Theme.Stroke
		UIStroke.Parent = SectionFrame

		UIShadow.BlurRadius = UDim.new(0, 20)
		UIShadow.Transparency = 0.500
		UIShadow.Parent = SectionFrame

		UICorner.Parent = SectionFrame

		UIListLayout.Parent = SectionFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Sealz:Tween(SectionFrame,Twnf,{
				Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + 5)
			})
		end);

		local Onload = function(value)
			Sealz:Tween(SectionFrame,Twnf,{
				BackgroundTransparency = value and 0.05 or 1
			})	

			Sealz:Tween(Label,Twnf,{
				TextTransparency = value and 0 or 1
			})

			Sealz:Tween(Icon,Twnf,{
				TextTransparency = value and 0 or 1
			})

			Sealz:Tween(Line,Twnf,{
				BackgroundTransparency = value and 0 or 1
			})

			Sealz:Tween(UIStroke,Twnf,{
				Transparency = value and 0 or 1
			})

			Sealz:Tween(UIShadow,Twnf,{
				Transparency = value and 0.5 or 1
			})
		end;



		Signal:Connect(Onload);

		Onload(Signal:Get());

		local BlockHandle = Sealz:CreateBlockHandler(SectionFrame , Signal);

		BlockHandle.root = Sect;
		return BlockHandle;
	end;
	
	return Menu;
end

function Sealz:Watermark()
	local Watermark = {};
	local signal = CreateSignal(true);
	local WatermarkFrame = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UIShadow = Instance.new("UIShadow")
	local UICorner = Instance.new("UICorner")
	local UIListLayout = Instance.new("UIListLayout")

	WatermarkFrame.Name = "WatermarkFrame"
	WatermarkFrame.Parent = Sealz.ScreenGui
	WatermarkFrame.AnchorPoint = Vector2.new(0.5, 0)
	WatermarkFrame.BackgroundColor3 = Sealz.Theme.Background
	WatermarkFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WatermarkFrame.BorderSizePixel = 0
	WatermarkFrame.ClipsDescendants = true
	WatermarkFrame.Position = UDim2.new(0.5, 0, 0, 15)
	WatermarkFrame.Size = UDim2.new(0, 193, 0, 30)
	WatermarkFrame.ZIndex = 525

	UIStroke.Color = Sealz.Theme.Stroke
	UIStroke.Parent = WatermarkFrame

	UIShadow.BlurRadius = UDim.new(0, 20)
	UIShadow.Transparency = 0.500
	UIShadow.Parent = WatermarkFrame

	UICorner.Parent = WatermarkFrame

	UIListLayout.Parent = WatermarkFrame
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		Sealz:Tween(WatermarkFrame,Twnf,{
			Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + 10, 0, 30)
		})
	end)

	signal:Connect(function(val)
		Sealz:Tween(WatermarkFrame,Twnf,{
			BackgroundTransparency = val and 0.075 or 1
		})

		Sealz:Tween(UIShadow,Twnf,{
			Transparency = val and 0.5 or 1
		})

		Sealz:Tween(UIStroke,Twnf,{
			Transparency = val and 0 or 1
		})
	end)

	function Watermark:SetVisible(v)
		if signal:Get() == v then
			return
		end
		signal:Fire(v)
	end;

	function Watermark:SetPosition(pos: string)
		if pos:lower() == "left" then
			Sealz:Tween(WatermarkFrame,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 15, 0, 15)
			})
		elseif pos:lower() == "center" or pos:lower() == "middle" then
			Sealz:Tween(WatermarkFrame,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 15)
			})
		elseif pos:lower() == "right" then
			Sealz:Tween(WatermarkFrame,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),{
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -15, 0, 15)
			})
		end;
	end;

	function Watermark.new(icon: string, content: string)
		local WatermarkItemFrame = Instance.new("Frame")
		local Label = Instance.new("TextLabel")
		local UIGradient = Instance.new("UIGradient")
		local Icon = Instance.new("TextLabel")
		local UIGradient_2 = Instance.new("UIGradient")

		WatermarkItemFrame.Name = "WatermarkItemFrame"
		WatermarkItemFrame.Parent = WatermarkFrame
		WatermarkItemFrame.BackgroundColor3 = Sealz.Theme.AccentColor
		WatermarkItemFrame.BackgroundTransparency = 1.000
		WatermarkItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		WatermarkItemFrame.BorderSizePixel = 0
		WatermarkItemFrame.ClipsDescendants = true
		WatermarkItemFrame.Size = UDim2.new(0, 100, 1, 0)
		WatermarkItemFrame.ZIndex = 526

		Label.Name = "Label"
		Label.Parent = WatermarkItemFrame
		Label.AnchorPoint = Vector2.new(0, 0.5)
		Label.BackgroundColor3 = Sealz.Theme.AccentColor
		Label.BackgroundTransparency = 1.000
		Label.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Label.BorderSizePixel = 0
		Label.Position = UDim2.new(0, 30, 0.5, 0)
		Label.Size = UDim2.new(1, -30, 0, 15)
		Label.ZIndex = 529
		Label.FontFace = Sealz.BoldFont
		Label.Text = content
		Label.TextColor3 = Sealz.Theme.AccentColor
		Label.TextSize = 12.000
		Label.RichText = true;
		Label.TextTransparency = 0.250
		Label.TextXAlignment = Enum.TextXAlignment.Left

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
		UIGradient.Rotation = 90
		UIGradient.Parent = Label

		Icon.Name = "Icon"
		Icon.Parent = WatermarkItemFrame
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Sealz.Theme.AccentColor
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 1, 0.5, 0)
		Icon.Size = UDim2.new(0, 25, 0, 25)
		Icon.ZIndex = 529
		Icon.FontFace = Sealz.IconFont
		Icon.Text =  icon
		Icon.TextColor3 = Sealz.Theme.AccentColor
		Icon.TextSize = 16.000
		Icon.TextWrapped = true

		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Sealz.Theme.AccentColor), ColorSequenceKeypoint.new(1.00, Sealz.Theme.Highlight)}
		UIGradient_2.Rotation = 90
		UIGradient_2.Parent = Icon


		local update = function()
			local Size = Sealz:GetTextSize(Label);

			Sealz:Tween(WatermarkItemFrame,Twnf,{
				Size = UDim2.new(0, Size.x + 35, 1, 0)
			})
		end;

		local Visible = function(val)
			Sealz:Tween(Label,Twnf,{
				TextTransparency = val and 0.250 or 1
			})


			Sealz:Tween(Icon,Twnf,{
				TextTransparency = val and 0 or 1
			})

			if val then

				update()
			else
				Sealz:Tween(WatermarkItemFrame,Twnf,{
					Size = UDim2.new(0, 0, 1, 0)
				})
			end
		end;

		update();

		local data = {};
		data.IVisible = true;

		function data:SetText(text)
			Label.Text = text;

			if data.IVisible then
				update();
			end;
		end;

		function data:Input(callback)
			return Sealz:AddInput(WatermarkItemFrame,callback);
		end;


		function data:SetVisible(text)
			if data.IVisible == text then
				return
			end;

			data.IVisible = text;
			Visible(text)
		end;

		signal:Connect(function(val)

			if val then

				if data.IVisible then
					Visible(true)
					update();
				end
			else
				Visible(false);
			end
		end)

		return data;
	end;

	return Watermark;
end

function Sealz:RichText(text)
	local still = {};
	still.text = text;
	still.build = {};

	function still.color(color)
		local r,g,b = math.floor(color.R*255),math.floor(color.G*255),math.floor(color.B*255)

		table.insert(still.build,`color="rgb({r}, {g}, {b})"`);
		return still
	end;

	function still.red()
		local color = Color3.fromRGB(255, 116, 118)
		local r,g,b = math.floor(color.R*255),math.floor(color.G*255),math.floor(color.B*255)

		table.insert(still.build,`color="rgb({r}, {g}, {b})"`);
		return still
	end;

	function still.green()
		local color = Color3.fromRGB(119, 255, 128)
		local r,g,b = math.floor(color.R*255),math.floor(color.G*255),math.floor(color.B*255)

		table.insert(still.build,`color="rgb({r}, {g}, {b})"`);
		return still
	end;

	function still.white()
		local color = Sealz.Theme.AccentColor
		local r,g,b = math.floor(color.R*255),math.floor(color.G*255),math.floor(color.B*255)

		table.insert(still.build,`color="rgb({r}, {g}, {b})"`);
		return still
	end;


	function still.size(size)
		table.insert(still.build,`size="{size}"`);
		return still
	end;

	function still.face(v)
		table.insert(still.build,`face="{v}"`);
		return still
	end;

	function still.transparency(v)
		table.insert(still.build,`transparency="{v}"`);
		return still
	end;

	function still.output(c)
		local d = table.concat(still.build,' ');

		return `<font {d}>{c or still.text}</font>`
	end;

	return still;
end;


function Sealz:Notification() : {new: (args: {Title: string, Content: string, Duration: number}) -> any}
	if Sealz.NOTIFY_CACHE then
		return Sealz.NOTIFY_CACHE;
	end;

	local NotifyContainer = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	NotifyContainer.Parent = Sealz.ScreenGui
	NotifyContainer.AnchorPoint = Vector2.new(1, 0)
	NotifyContainer.BackgroundColor3 = Sealz.Theme.AccentColor
	NotifyContainer.BackgroundTransparency = 1.000
	NotifyContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NotifyContainer.BorderSizePixel = 0
	NotifyContainer.Position = UDim2.new(1, -10, 0, 55)
	NotifyContainer.Size = UDim2.new(0, 100, 0, 100)

	UIListLayout.Parent = NotifyContainer
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 3)

	local LayoutREF = 0;

	Sealz.NOTIFY_CACHE = {
		new = function(Notify)
			Notify = Sealz:Format(Notify, {
				Title = "Notification",
				Content = "Content",
				Duration = 3,
			});

			LayoutREF -= 5;

			local BlockFrame = Instance.new("Frame")
			local NotifyFrame = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Header = Instance.new("TextLabel")
			local Body = Instance.new("TextLabel")
			local TimeLeftFrame = Instance.new("Frame")
			local UICorner_2 = Instance.new("UICorner")
			local TimeLeft = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local Shadow = Sealz:AddShadow(NotifyFrame);

			BlockFrame.Parent = NotifyContainer
			BlockFrame.AnchorPoint = Vector2.new(1, 0)
			BlockFrame.BackgroundColor3 = Sealz.Theme.Background
			BlockFrame.BackgroundTransparency = 1.000
			BlockFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			BlockFrame.BorderSizePixel = 0
			BlockFrame.ClipsDescendants = false
			BlockFrame.Size = UDim2.new(0, 200, 0, 0)
			BlockFrame.LayoutOrder = LayoutREF;


			NotifyFrame.Parent = BlockFrame
			NotifyFrame.BackgroundColor3 = Sealz.Theme.Background
			NotifyFrame.BackgroundTransparency = 0.100
			NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			NotifyFrame.BorderSizePixel = 0
			NotifyFrame.ClipsDescendants = false
			NotifyFrame.Size = UDim2.new(1, 0, 1, -5)
			NotifyFrame.ZIndex = 2
			NotifyFrame.Position = UDim2.new(1,200,0,0)


			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = NotifyFrame

			Header.Parent = NotifyFrame
			Header.BackgroundColor3 = Sealz.Theme.AccentColor
			Header.BackgroundTransparency = 1.000
			Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Header.BorderSizePixel = 0
			Header.Position = UDim2.new(0, 10, 0, 10)
			Header.Size = UDim2.new(1, -50, 0, 15)
			Header.ZIndex = 3
			Header.FontFace = Sealz.BoldFont
			Header.Text = Notify.Title
			Header.RichText = true
			Header.TextColor3 = Sealz.Theme.White
			Header.TextSize = 14.000
			Header.TextXAlignment = Enum.TextXAlignment.Left

			Body.Parent = NotifyFrame
			Body.BackgroundColor3 = Sealz.Theme.AccentColor
			Body.BackgroundTransparency = 1.000
			Body.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Body.BorderSizePixel = 0
			Body.Position = UDim2.new(0, 10, 0, 33)
			Body.Size = UDim2.new(1, -15, 0, 30)
			Body.ZIndex = 3
			Body.FontFace = Sealz.BoldFont
			Body.Text = Notify.Content
			Body.TextColor3 = Sealz.Theme.White
			Body.TextSize = 12.000
			Body.RichText = true;
			Body.TextTransparency = 0.500
			Body.TextXAlignment = Enum.TextXAlignment.Left
			Body.TextYAlignment = Enum.TextYAlignment.Top

			TimeLeftFrame.Parent = NotifyFrame
			TimeLeftFrame.AnchorPoint = Vector2.new(0, 1)
			TimeLeftFrame.BackgroundColor3 = Sealz.Theme.AccentColor
			TimeLeftFrame.BackgroundTransparency = 1.000
			TimeLeftFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TimeLeftFrame.BorderSizePixel = 0
			TimeLeftFrame.Position = UDim2.new(0, 0, 1, 1)
			TimeLeftFrame.Size = UDim2.new(1, 0, 0, 5)
			TimeLeftFrame.ZIndex = 5

			UICorner_2.CornerRadius = UDim.new(0, 4)
			UICorner_2.Parent = TimeLeftFrame

			TimeLeft.Parent = TimeLeftFrame
			TimeLeft.BackgroundColor3 = Sealz.Theme.White
			TimeLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TimeLeft.BorderSizePixel = 0
			TimeLeft.Size = UDim2.new(0, 0, 1, 0)
			TimeLeft.ZIndex = 5

			UICorner_3.CornerRadius = UDim.new(0, 1)
			UICorner_3.Parent = TimeLeft

			local UpdateText = function()
				local TitleScale = Sealz:GetTextSize(Header);
				local BodyScale = Sealz:GetTextSize(Body);

				local MainX = (TitleScale.X >= BodyScale.X and TitleScale.X) or BodyScale.X;
				local MainY = TitleScale.Y + ((Body.Text:byte() and BodyScale.Y) or 1);

				if BlockFrame:GetAttribute('Already') then
					Sealz:Tween(BlockFrame,Twnf,{
						Size = UDim2.new(0,MainX + 55,0,MainY + 35)
					});
				else
					BlockFrame:SetAttribute('Already',true)
					BlockFrame.Size = UDim2.new(0, MainX + 45, 0, 0);

					Sealz:Tween(BlockFrame,Twnf,{
						Size = UDim2.new(0,MainX + 55,0,MainY + 35)
					});
				end;
			end;

			UpdateText();

			local Close = function()
				Sealz:Tween(NotifyFrame,TweenInfo.new(0.65,Enum.EasingStyle.Quint),{
					Position = UDim2.new(1,200,0,0)
				});

				task.wait(0.3);

				Sealz:Tween(BlockFrame,TweenInfo.new(0.3),{
					Size = UDim2.new(1,0,0,0)
				});

				task.wait(0.35)
				BlockFrame:Destroy();

			end;

			local Show = function()
				Sealz:Tween(NotifyFrame,TweenInfo.new(0.5,Enum.EasingStyle.Quint),{
					Position = UDim2.new(0,0,0,0)
				});
			end;

			if typeof(Notify.Duration) == 'number' and Notify.Duration ~= math.huge then
				Sealz:Tween(TimeLeft,TweenInfo.new(Notify.Duration + 0.2,Enum.EasingStyle.Linear),{
					Size = UDim2.new(1, 0, 1, 0)
				});

				return task.delay(0.25,function()
					Show();

					task.delay(Notify.Duration + 0.2,Close)
				end);
			end;

			Show();

			return {
				Title = function(self , new)
					Header.Text = new;
					UpdateText(); 
				end,

				Content = function(self , new)
					Body.Text = new;
					UpdateText();
				end,

				SetProgress = function(self , new , Time)
					if Time and Time <= 0 then
						TimeLeft.Size = UDim2.new(new, 0, 1, 0);

						UpdateText();
						return;
					end;

					if new > 1 then
						new = (new / 100);	
					end;

					Sealz:Tween(TimeLeft,TweenInfo.new(Time or 0.85,(Time and Enum.EasingStyle.Linear) or Enum.EasingStyle.Quint),{
						Size = UDim2.new(new, 0, 1, 0)
					});

					UpdateText();
				end,

				Close = Close,
			}
		end,
	};

	return Sealz.NOTIFY_CACHE;
end;

return Sealz;