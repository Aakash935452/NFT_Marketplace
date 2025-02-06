pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTMarketplace is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct NFT {
        uint256 id;
        string uri;
        uint256 price;
        address payable creator;
        bool forSale;
    }

    mapping(uint256 => NFT) public nfts;

    constructor() ERC721("NFTMarketplace", "NFTM") {}

    function mintNFT(string memory tokenURI, uint256 price) public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);

        nfts[newItemId] = NFT(newItemId, tokenURI, price, payable(msg.sender), true);
    }

    function buyNFT(uint256 tokenId) public payable {
        NFT storage nft = nfts[tokenId];
        require(msg.value >= nft.price, "Not enough funds sent");
        require(nft.forSale, "NFT not for sale");

        _transfer(nft.creator, msg.sender, tokenId);
        nft.creator.transfer(msg.value);
        nft.forSale = false;
    }
}
