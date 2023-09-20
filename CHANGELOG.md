# 3.0.2
Bug fix (see issue [#37](https://github.com/hukusuke1007/stop_watch_timer/pull/37)).

## 3.0.1
Bug fix (see issue [#36](https://github.com/hukusuke1007/stop_watch_timer/issues/36)).

## 3.0.0
Update dependency constraints to sdk: '>=2.17.0 <4.0.0'.
Removed _executeController, execute, onExecute IF.

## 2.0.0
Breaking change
 - Renamed function. onStop => onStopped, fetchStop => fetchStopped
 - Changed timer execution IF.
   - onStartTimer, onStopTimer, onResetTimer, onAddLap
Fixed
 - Bug that caused 0 to be listened to during countdown.
 - Modified example code.
 - Updated README.

## 1.5.0
Setting specific values to timer (#27)

## 1.4.0
Added onStop callback and fetchStop stream, Added fetchEnded stream.

## 1.3.1
Modified initialPresetTime.

## 1.3.0
Can be set preset time in running timer. Added clearPresetTime and onEnded.

## 1.2.0+1
Modified README.

## 1.2.0
Updated Plugin.

## 1.1.0+1
Modified README.

## 1.1.0
Added count down mode.

## 1.0.0
Updated rxdart plugin.

## 0.8.0-nullsafety.0
Changed version.

## 0.7.0-nullsafety.0
Migrate this package to null safety.

## 0.7.0
Update Plugins

## 0.6.0+1
Updated README.

## 0.6.0
Added Hours Feature.
Added Set Preset Time Functions for Hours, Minute, Second.
Bug fix. 

## 0.5.0+1
Updated plugins.

## 0.5.0
Added preset time feature.

## 0.4.0
Updated rxdart plugin.

## 0.3.0
Added callback function of onChangeSecond and onChangeMinute.

## 0.2.0+2
Deleted unnecessary files.

## 0.2.0+1
Updated document.

## 0.2.0
Refactoring stream. Added RxDart.

## 0.1.2+1
Updated document.

## 0.1.2
Refactoring execute.

## 0.1.1
Added function of getDisplayTimeMinute, getDisplayTimeSecond, getDisplayTimeMilliSecond. Added callback function.

## 0.1.0+5
Updated gif.

## 0.1.0+4
Updated document.

## 0.1.0+3
Updated document.

## 0.1.0+2
Updated description.

## 0.1.0+1
Updated gif.

## 0.1.0
First release.