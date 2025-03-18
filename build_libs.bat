mkdir libs
mkdir libs\debug
mkdir libs\release

mkdir libexpat\expat\build
cd libexpat\expat\build

cmake .. -DEXPAT_SHARED_LIBS=OFF

cmake --build .
copy Debug\libexpatd.lib ..\..\..\libs\debug
copy Debug\libexpatd.pdb ..\..\..\libs\debug

cmake --build . --config Release
copy Release\libexpat.lib ..\..\..\libs\release