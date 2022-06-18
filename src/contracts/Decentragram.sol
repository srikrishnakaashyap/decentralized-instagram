pragma solidity >=0.6.0;

contract Decentragram {
    // Code goes here...
    string public name = "Decentragram";

    uint256 public imageCount = 0;
    struct Image {
        uint256 id;
        string hash;
        string description;
        uint256 tipAmount;
        address payable author;
    }

    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    mapping(uint256 => Image) public images;

    function uploadImage(string memory _imageHash, string memory _description)
        public
    {
        require(bytes(_imageHash).length > 0, "Invalid Image Hash");
        require(bytes(_description).length > 0, "Invalid Description");

        require(msg.sender != address(0x0), "Invalid Sender");

        imageCount++;

        address payable _sender = payable(msg.sender);
        images[imageCount] = Image(
            imageCount,
            _imageHash,
            _description,
            0,
            _sender
        );

        emit ImageCreated(
            imageCount,
            _imageHash,
            _description,
            0,
            payable(msg.sender)
        );
    }

    function tipImageOwner(uint256 _id) public payable {
        require(_id > 0 && _id <= imageCount);
        Image memory _image = images[_id];

        address payable _author = _image.author;

        _author.transfer(msg.value);

        _image.tipAmount += msg.value;

        images[_id] = _image;

        emit ImageTipped(
            _id,
            _image.hash,
            _image.description,
            msg.value,
            payable(msg.sender)
        );
    }
}
