// TKBMS v1.0 -----------------------------------------------------
//
// PLATFORM       : ALL 
// PRODUCT        : VISION 
// VISIBILITY     : PUBLIC
//
// ------------------------------------------------------TKBMS v1.0

#if !defined(GAMEPLUGINPCH_H_INCLUDED)
#define GAMEPLUGINPCH_H_INCLUDED

#if defined(WIN32)

#define WIN32_LEAN_AND_MEAN    // Exclude rarely-used stuff from Windows headers

#endif

#include <Vision/Runtime/Base/VBase.hpp>
#include <Vision/Runtime/Engine/System/Vision.hpp>
#include <Vision/Runtime/Common/VisSampleApp.hpp>

#include <Vision/Runtime/EnginePlugins/EnginePluginsImport.hpp>

extern VModule g_myComponentModule;

#endif
