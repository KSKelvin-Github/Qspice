# Ø-Device Pin Definition in .qsch or .qsym

## Procedure to assign Port and Data Type of DLL-device from Text Editor
Step 1: Use text editor[^1] to open .qsch or .qsym with Ø-Device

Step 2: Pin is described as **«pin (-2300,1000) (0,0) 0.926 7 `17` 0x0 -1 "InputBoolean"»**

| Item | Description |
| ----------- | ----------- |
| (-2300,1000) | pin position |
| (0,0) | pin label position offset |
|0.926|font size|
|7|pin label justification|
|`17`|**port and data Type**|
|0x0||
|-1||
|"InputBoolean"|pin label|


Step 3: Modify **port and data type** (`17`) with text editor by referring to table below
- e.g. To assign an Output Port, Float, replace `17` by `146`

|Data Type| Port : Input | Port : Output | Port : DLL's GND |
| ----------- | ----------- | ----------- | ----------- |
||1|2|3|
|**Boolean**|**17**|**18**||
|Char|33|34||
|Unsigned Char|49|50||
|Short|65|66||
|Unsigned Short|81|82||
|**Integer**|**97**|**98**||
|Unsigned Integer|113|114||
|Short Float32|129|130||
|**Float**|**145**|**146**||
|Integer64|161|162||
|Unsigned Integer 64|177|178||


[^1]: Text Editor : [Notepad++ : https://notepad-plus-plus.org/](https://notepad-plus-plus.org/)