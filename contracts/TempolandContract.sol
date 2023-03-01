// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ownable.sol";
import "./nf-token-metadata.sol";

//import "openzeppelin-solidity/contracts/access/Ownable.sol";
//import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

//import "openzeppelin-solidity/contracts/payment/PullPayment.sol";

contract TempolandContract is NFTokenMetadata, Ownable {
    uint256 public constant PRICEYEAR = 100000;
    uint256 public constant PRICEMONTH = 10000;
    uint256 public constant PRICEDAY = 5000;

    event Received(address indexed _to, uint256 _value, string message);

    struct Royal_year {
        uint256 id;
        address payable buyer;
        uint256 createdAt;
    }
    struct Royal_month {
        uint256 id;
        address payable buyer;
        uint256 royal_father;
        uint256 createdAt;
    }
    struct Royal_day {
        uint256 id;
        address payable buyer;
        uint256 royal_father;
        uint256 createdAt;
    }

    mapping(uint256 => Royal_year) public royal_years;
    mapping(uint256 => Royal_month) public royal_months;
    mapping(uint256 => Royal_day) public royal_days;

    constructor() payable {
        nftName = "tempolands NFT";
        nftSymbol = "TEMSNFT";
        supportedInterfaces[0x80ac58cd] = true; // ERC721
        owner = payable(msg.sender);
    }

    function father_define(
        address payable _buyer,
        uint256 _idToken,
        string memory _class,
        uint256 _idfather,
        uint256 _value
    ) public {
        if (converStringToCode(_class, "year")) {
            if (haveOwner(_idToken)) {
                address payable _oldOwner = royal_years[_idToken].buyer;
                _oldOwner.transfer((_value / 100) * 90);
                findOwner(_idToken, _buyer);
            }
            royal_years[_idToken] = Royal_year(
                _idToken,
                _buyer,
                block.timestamp
            );
        }
        if (converStringToCode(_class, "month")) {
            address payable _addressFather = royal_years[_idfather].buyer;
            if (haveOwner(_idToken)) {
                address payable _oldOwner = royal_months[_idToken].buyer;
                _oldOwner.transfer((_value / 100) * 90);
                findOwner(_idToken, _buyer);
            }
            royal_months[_idToken] = Royal_month(
                _idToken,
                _buyer,
                _idfather,
                block.timestamp
            );
            _addressFather.transfer((_value / 100) * 2);
        }
        if (converStringToCode(_class, "day")) {
            address payable _addressFather = royal_months[_idfather].buyer;
            address payable _addressKingFather = getRoyalKing(_idfather);
            if (haveOwner(_idToken)) {
                address payable _oldOwner = royal_days[_idToken].buyer;
                _oldOwner.transfer((_value / 100) * 90);
                findOwner(_idToken, _buyer);
            }
            royal_days[_idToken] = Royal_day(
                _idToken,
                _buyer,
                _idfather,
                block.timestamp
            );
            uint256 valueToMonth = (_value / 100) * 2;
            uint256 valueToYear = (_value / 100) * 2;
            _addressFather.transfer(valueToMonth);
            _addressKingFather.transfer(valueToYear);
        }
    }

    function getRoyalKing(uint256 _fatherId)
        internal
        view
        returns (address payable)
    {
        uint256 _royal_year_id = royal_months[_fatherId].royal_father;
        return royal_years[_royal_year_id].buyer;
    }

    function converStringToCode(string memory word_1, string memory word_2)
        internal
        pure
        returns (bool)
    {
        return
            keccak256(abi.encodePacked(word_1)) ==
            keccak256(abi.encodePacked(word_2));
    }

    function haveOwner(uint256 _tokenId) public view returns (bool) {
        if (
            royal_days[_tokenId].id > 0 ||
            royal_months[_tokenId].id > 0 ||
            royal_years[_tokenId].id > 0
        ) {
            return true;
        }
        return false;
    }

    function findOwner(uint256 _tokenId, address payable _buyer) public {
        if (royal_days[_tokenId].id == _tokenId) {
            Royal_day memory royal = royal_days[_tokenId];
            royal.buyer = _buyer;
            royal_days[_tokenId] = royal;
        }
        if (royal_months[_tokenId].id == _tokenId) {
            Royal_month memory royal = royal_months[_tokenId];
            royal.buyer = _buyer;
            royal_months[_tokenId] = royal;
        }
        if (royal_years[_tokenId].id == _tokenId) {
            Royal_year memory royal = royal_years[_tokenId];
            royal.buyer = _buyer;
            royal_years[_tokenId] = royal;
        }
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function mint(
        address payable _to,
        uint256 _tokenId,
        string memory _tokenClass,
        uint256 _idFather,
        string calldata _uri
    ) public payable {
        //require(false, string(toAsciiString(owner)));
        if (msg.sender == owner) {
            withdraw();
        } else {
            if (converStringToCode(_tokenClass, "year")) {
                require(
                    msg.value >= PRICEYEAR,
                    "Insufficient payment ETH per item"
                );
            } else if (converStringToCode(_tokenClass, "month")) {
                require(
                    msg.value >= PRICEMONTH,
                    "Insufficient payment ETH per item"
                );
            } else if (converStringToCode(_tokenClass, "day")) {
                require(
                    msg.value >= PRICEDAY,
                    "Insufficient payment ETH per item"
                );
            } else {
                require(false, "token class not valid");
            }
        }

        _mint(_to, _tokenId);
        _setTokenUri(_tokenId, _uri);

        father_define(_to, _tokenId, _tokenClass, _idFather, (msg.value));

        emit Received(msg.sender, msg.value, "deposito");
    }

    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint256 i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2 * i] = char(hi);
            s[2 * i + 1] = char(lo);
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }


    function _baseURI() internal view virtual returns (string memory) {
        return "https://croonos.io/assest";
    }

    

    function withdraw() public onlyOwner {
        // get the amount of Ether stored in this contract

        uint256 amount = address(this).balance;

        // send all Ether to owner
        // Owner can receive Ether since the address of owner is payable

        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }
}
