// TKBMS v1.0 -----------------------------------------------------
//
// PLATFORM       : ALL 
// PRODUCT        : VISION 
// VISIBILITY     : PUBLIC
//
// ------------------------------------------------------TKBMS v1.0

// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(GAMEAPPLICATIONPCH_H_INCLUDED)
#define GAMEAPPLICATIONPCH_H_INCLUDED

#if defined(WIN32)

#define WIN32_LEAN_AND_MEAN    // Exclude rarely-used stuff from Windows headers

#endif

#define VISION_SAMPLEAPP_CALLBACKS

#include <Vision/Runtime/Base/VBase.hpp>
#include <Vision/Runtime/Engine/System/Vision.hpp>
#include <Vision/Runtime/Common/VisSampleApp.hpp>

#include <Vision/Runtime/EnginePlugins/EnginePluginsImport.hpp>
// TODO: reference additional headers your program requires here

#endif

