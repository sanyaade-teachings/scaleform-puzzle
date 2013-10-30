-- Scaleform Lua Script Demonstration

--initialize some global values
mainMovie = nil
mainMenu = nil

function OnAfterSceneLoaded()
  Debug:Enable(true)
  local cam01 = Game:GetEntity("CameraPos")
  local mainCam = Game:GetCamera()
  
  mainCam:Set(cam01:GetRotationMatrix(), cam01:GetPosition())

  --load the havok movie
  
  mainMovie = Scaleform:LoadMovie("Flash/bin/HavokPuzzle.swf", 0, 0)
  Scaleform:SetAbsoluteCursorPositioning(true)
  
  GUI:LoadResourceFile("GUI/MenuSystem.xml")
  GUI:SetCursorVisible(true)
end

function OnAfterSceneUnloaded()
 
  --hide the cursor again
  GUI:SetCursorVisible(false)
  
  if Scaleform == nil then return end
  
  --avoid access in OnUpdateSceneBegin
  --(next time running the scene in vForge)
  mainMovie = nil
  mainMenu = nil
  
  --unload all movies
	Scaleform:UnloadAllMovies() 
end

function OnUpdateSceneBegin()

end

--this callback is invoked by the Scaleform movie
function OnExternalInterfaceCall(movie, command, argTable)
  Debug:PrintLine("External Interface Call: " .. command .. ": " .. #argTable .. " args")
  if command == "CreateEffect" and #argTable==3 then
     
    local x,y = Screen:GetViewportSize()
    local xMediator = 0
    local yMediator = 0
    local scale = 0
    if( x/y > 640/960) then
      scale = y/960
      xMediator = (x - scale*640)/2
      yMediator = 0
    else
      scale = x/640
      xMediator = 0
      yMediator = (y - scale*960)/2
    end
    
    
    local pos = Screen:PickPoint(argTable[2]*scale + xMediator, argTable[3]*scale + yMediator)
    
    Debug:PrintLine("PickPoint pos" .. pos.. ": " .. argTable[2].. ": " .. argTable[3])
    
    local particle = Game:CreateEffect( pos, "Effects/AnarchyEffect.xml")  
    particle:SetScaling(scale)
  end
end

--this callback is invoked by the Scaleform movie
function OnFsCommand(movie, command, argument)
  Debug:PrintLine("FS Command: " .. command .. " : " .. argument)
end

