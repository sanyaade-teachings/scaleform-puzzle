// TKBMS v1.0 -----------------------------------------------------
//
// PLATFORM       : ALL
// PRODUCT        : VISION 
// VISIBILITY     : PUBLIC
//
// ------------------------------------------------------TKBMS v1.0

//#include "stdafx.h" // Requires for sample dependent settings e.g. 

#include <Vision/Runtime/Base/VBase.hpp>

#include <Vision/Runtime/Common/VisSampleApp.hpp>

VISION_CALLBACK void VisionSampleAppAfterLoadingFunction();
VISION_CALLBACK bool VisionSampleAppRunFunction();

VISION_RUN
{
  //check if the scene loading is finished
  VisSampleApp::ApplicationState appState = static_cast<VisSampleApp*>(Vision::GetApplication())->GetApplicationState();
  if (appState == VisSampleApp::AS_LOADING)
  {
    return true;
  }
  else if (appState == VisSampleApp::AS_LOADING_ERROR)
  {
    return false;
  }
  else if (appState == VisSampleApp::AS_AFTER_LOADING)
  {
    VisionSampleAppAfterLoadingFunction();
  }  
  return VisionSampleAppRunFunction();
}

