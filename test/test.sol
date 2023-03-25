pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFTContract is ERC721 {
    uint256 public tokenCounter;
    constructor() ERC721("MyNFT", "NFT") {
        tokenCounter = 0;
    }
    struct NFTData {
        uint256 tokenId;
        string svg;
    }
    mapping(uint256 => NFTData) public nftData;
    function mint() public {
        uint256 tokenId = tokenCounter;
        _safeMint(msg.sender, tokenId);

        string memory svg = generateSVG(tokenId);
        nftData[tokenId] = NFTData(tokenId, svg);

        emit Transfer(address(0), msg.sender, tokenId);
        tokenCounter++;
    }
    function getSVG(uint256 _tokenId) public view returns (string memory) {
        return nftData[_tokenId].svg;
    }
    function generateSVG(uint256 seed) internal pure returns (string memory) {
        string[11] memory colors = ["red", "blue", "green", "yellow", "orange", "pink", "purple", "gray", "black", "white", "brown"];
        string memory svg = string(abi.encodePacked("<svg xmlns='http://www.w3.org/2000/svg' width='100' height='100'>"));

        for (uint256 i = 0; i < 10; i++) {
            uint256 randomIndex = uint256(keccak256(abi.encode(seed, i))) % colors.length;
            svg = string(abi.encodePacked(svg, "<circle cx='", uint256(keccak256(abi.encode(seed, i, "cx"))).toString(), "' cy='", uint256(keccak256(abi.encode(seed, i, "cy"))).toString(), "' r='", uint256(keccak256(abi.encode(seed, i, "r"))).toString(), "' fill='", colors[randomIndex], "' />"));
        }

        svg = string(abi.encodePacked(svg, "</svg>"));
        return svg;
    }
}
