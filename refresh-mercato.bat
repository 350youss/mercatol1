@echo off
REM ============================================================
REM  Rafraichissement auto du recap mercato Ligue 1
REM  - scrape Transfermarkt -> regenere index.html + equipe.html
REM  - copie vers le repo dedie "mercatol1" et publie sur GitHub Pages
REM    (uniquement si les DONNEES ont change)
REM ============================================================
setlocal
set "PUSH=1"
set "REPO=C:\Users\Youss\Documents\mercato-l1-repo"

cd /d "%~dp0"
echo [%date% %time%] Scrape mercato L1...
python "scripts\scrape_l1_transfers.py"
if errorlevel 1 (
  echo ECHEC du scrape, publication annulee.
  exit /b 1
)

if not "%PUSH%"=="1" goto :done

set "CHANGED=0"
if exist "data\.push" set /p CHANGED=<"data\.push"
if not "%CHANGED%"=="1" (
  echo Donnees inchangees, pas de publication.
  goto :done
)

copy /y "index.html" "%REPO%\index.html" >nul
copy /y "equipe.html" "%REPO%\equipe.html" >nul
copy /y "data\transfers_l1.json" "%REPO%\data\transfers_l1.json" >nul
xcopy /y /q "logos\*.*" "%REPO%\logos\" >nul

pushd "%REPO%"
git add index.html equipe.html data\transfers_l1.json logos
git commit -m "MAJ mercato L1 (auto)"
git push
echo Publie sur GitHub Pages (mercatol1).
popd

:done
endlocal
