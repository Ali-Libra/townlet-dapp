./solc-windows.exe --abi --bin --overwrite -o build ../contracts/Towns.sol
./abigen.exe --bin=build/Towns.bin --abi=build/Towns.abi --pkg=town --out=build/towns.go