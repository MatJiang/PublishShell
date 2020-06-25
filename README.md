# PublishShell

Get files from a directory with recursive, and replace path string to check the same folder structure files.

Copy target files to backup folder,and copy source files to overwrite target files.

Execute .ps1 file by double click to open .bat file

***
這是一個PowerShell練習

在一個資料夾下準備相同資料夾結構的檔案

透過PowerShell語法將來源檔案複製到目標資料夾

經由路徑置換方式檢查目標資料夾是否存在相同的檔案

- 存在 - 備份一份到備份資料夾，路徑資料寫入Copied.log.txt檔案
- 不存在 - 路徑資料寫入NewFile.log.txt檔案

檢查完畢後，將檔案覆蓋到目標資料夾中

批次檔(publish.bat)為執行相同目錄下的publish.ps1，提供使用者能直接透過點擊觸發
