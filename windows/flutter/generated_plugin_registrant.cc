//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

<<<<<<< Updated upstream
#include <file_selector_windows/file_selector_windows.h>
=======
>>>>>>> Stashed changes
#include <firebase_core/firebase_core_plugin_c_api.h>
#include <syncfusion_pdfviewer_windows/syncfusion_pdfviewer_windows_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
<<<<<<< Updated upstream
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
=======
>>>>>>> Stashed changes
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
  SyncfusionPdfviewerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SyncfusionPdfviewerWindowsPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
