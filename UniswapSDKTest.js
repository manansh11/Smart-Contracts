const { ChainId, Fetcher, WETH, Route, Trade, TokenAmount, TradeType, Percent } = require('@uniswap/sdk');
const chainId = ChainId.MAINNET;
const ethers = require('ethers');

//DAI Token Address
const tokenAddress = '0x6b175474e89094c44da98b954eedeac495271d0f';

// Init 
const init = async () => {
    const dai = await Fetcher.fetchTokenData(chainId, tokenAddress);
    const weth = WETH[chainId];
    const pair = await Fetcher.fetchPairData(dai, weth);
    const route = new Route([pair], weth);
    const trade = new Trade(route, new TokenAmount(weth, '1000000000000000000'), TradeType.EXACT_INPUT);


    console.log(route.midPrice.toSignificant(6));
    console.log(route.midPrice.invert().toSignificant(6));
    console.log(trade.executionPrice.toSignificant(6));
    console.log(trade.nextMidPrice.toSignificant(6));

    const slippageTolerance = new Percent('50', '10000')        // 50 Bips -> 1 Bips is 0.001%
    const amountOutMin = trade.minimumAmountOut(slippageTolerance).raw;
    const path = [weth.address, dai.address];
    const to = '';
    const deadline = Math.floor(Date.now() / 1000) + 60 * 20;
    const value = trade.inputAmount.raw

    //Uniswap SDK will not allow us to execute trades -> read data only
    //Will use Ethers to execute trades

    const providers = ethers.getDefaultProvider('mainnet', {
        infura: 'https://mainnet.infura.io/v3/b75353f472fd4e2492390f612fc91ff7'
    });

    const signer = new ethers.Wallet(PRIVATE_KEY);
    const accounts = signer.connect(provider);
    const uniswap = new ethers.Contract(
        '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',
        ['function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts)'], account);

    const tx = await uniswap.sendExactETHForTokens(
        amountOutMin,
        path,
        to,
        deadline,
        { value, gasPrice: 20e9 }
    );

    console.log(`Transaction Hash: ${tx.hash}`);
    const recipt = await tx.wait();

    console.log(`Transaction was mined in block ${recipt.blockNumber}`);

}

init();
