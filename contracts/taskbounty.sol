// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract TaskBounty {
    // Struct to store task details
    struct Task {
        address creator; // Task creator's address
        string description; // Task description (short, to save gas)
        uint256 bounty; // Bounty amount in tCORE2
        address worker; // Worker who submitted the task
        bool isCompleted; // Task completion status
        bool isApproved; // Task approval status
    }

    // Mapping to store tasks by ID
    mapping(uint256 => Task) public tasks;
    uint256 public taskCount; // Counter for task IDs

    // Event to log task creation
    event TaskCreated(uint256 taskId, address creator, string description, uint256 bounty);
    // Event to log task submission
    event TaskSubmitted(uint256 taskId, address worker);
    // Event to log task approval
    event TaskApproved(uint256 taskId, address worker, uint256 bounty);

    // Function to create a new task with a bounty
    function createTask(string memory _description) external payable {
        require(msg.value > 0, "Bounty must be greater than 0");
        taskCount++;
        tasks[taskCount] = Task({
            creator: msg.sender,
            description: _description,
            bounty: msg.value,
            worker: address(0),
            isCompleted: false,
            isApproved: false
        });
        emit TaskCreated(taskCount, msg.sender, _description, msg.value);
    }

    // Function for a worker to submit task completion
    function submitTask(uint256 _taskId) external {
        Task storage task = tasks[_taskId];
        require(task.creator != address(0), "Task does not exist");
        require(!task.isCompleted, "Task already completed");
        require(task.worker == address(0), "Task already claimed");
        task.worker = msg.sender;
        task.isCompleted = true;
        emit TaskSubmitted(_taskId, msg.sender);
    }

    // Function for task creator to approve and release bounty
    function approveTask(uint256 _taskId) external {
        Task storage task = tasks[_taskId];
        require(task.creator == msg.sender, "Only creator can approve");
        require(task.isCompleted, "Task not yet submitted");
        require(!task.isApproved, "Task already approved");
        task.isApproved = true;
        payable(task.worker).transfer(task.bounty);
        emit TaskApproved(_taskId, task.worker, task.bounty);
    }

    // Function to get task details (optional, for testing)
    function getTask(uint256 _taskId) external view returns (
        address creator,
        string memory description,
        uint256 bounty,
        address worker,
        bool isCompleted,
        bool isApproved
    ) {
        Task memory task = tasks[_taskId];
        return (
            task.creator,
            task.description,
            task.bounty,
            task.worker,
            task.isCompleted,
            task.isApproved
        );
    }
}
