./solc-windows.exe --abi --bin --overwrite -o build ../contracts/TownList.sol
./abigen.exe --bin=build/TownList.bin --abi=build/TownList.abi --pkg=town_list --out=build/town_list.go