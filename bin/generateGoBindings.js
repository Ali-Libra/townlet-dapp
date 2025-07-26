const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

// 配置参数
const CONTRACTS = ["Towns", "TownMaps"]; // 要处理的合约列表
const PACKNAME = ["towns", "town_maps"]; // 要处理的合约列表
const ARTIFACTS_DIR = "../artifacts/contracts"; // Hardhat 生成的 artifacts 路径
const ABIGEN_PATH = "abigen.exe"; // abigen 工具路径

  if (!fs.existsSync("./go")) {
    fs.mkdirSync("./go", { recursive: true });
  }

// 处理每个合约
CONTRACTS.forEach((CONTRACT_NAME, index) => {
  try {
    console.log(`\n🔨 Processing contract: ${CONTRACT_NAME}`);

    // 1. 读取 ABI 和 Bytecode
    const artifactPath = path.join(
      ARTIFACTS_DIR,
      `${CONTRACT_NAME}.sol/${CONTRACT_NAME}.json`
    );
    const artifact = JSON.parse(fs.readFileSync(artifactPath, "utf-8"));

    const abi = JSON.stringify(artifact.abi);
    const bytecode = artifact.bytecode;

    console.log(`✅ Loaded ABI and Bytecode for ${CONTRACT_NAME}`);

    // 2. 创建临时文件
    const tempAbiFile = path.join(__dirname, `${CONTRACT_NAME}.abi`);
    const tempBinFile = path.join(__dirname, `${CONTRACT_NAME}.bin`);

    fs.writeFileSync(tempAbiFile, abi);
    fs.writeFileSync(tempBinFile, bytecode);

    console.log(`📄 Temporary files generated: ${tempAbiFile}, ${tempBinFile}`);

    
    // 确保输出目录存在
    const packName = PACKNAME[index]
    if (!fs.existsSync(packName)) {
      fs.mkdirSync(packName, { recursive: true });
    }
    // 3. 调用 abigen 生成 Go 文件
    const cmd = `${ABIGEN_PATH} --abi ${tempAbiFile} --bin ${tempBinFile} --pkg ${packName} --out ${path.join(
      'go/'+packName,
      `${CONTRACT_NAME}.go`
    )}`;
    console.log(`⚙️ Running: ${cmd}`);

    execSync(cmd, { stdio: "inherit" });
    console.log(
      `🎉 Go binding generated at ${path.join(packName, `${CONTRACT_NAME}.go`)}`
    );

    // // 4. 清理临时文件
    // fs.unlinkSync(tempAbiFile);
    // fs.unlinkSync(tempBinFile);
    console.log("🧹 Temporary files cleaned up");
  } catch (error) {
    console.error(`❌ Error processing ${CONTRACT_NAME}:`, error.message);
  }
});

console.log("\n✨ All contracts processed!");