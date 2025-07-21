./solc-windows.exe --abi --bin --overwrite -o build ../contracts/TownRegister.sol
./abigen.exe --bin=build/TownRegistry.bin --abi=build/TownRegistry.abi --pkg=town --out=build/town_registry.go