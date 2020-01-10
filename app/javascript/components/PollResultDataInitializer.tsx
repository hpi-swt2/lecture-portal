export default class PollResultDataInitializer {
    private allVotesCount;
    private poll_data;

    constructor(poll_options) {
        this.allVotesCount = poll_options.poll_options.map(option => option.votes).reduce((a, b) => a + b, 0);
        this.allVotesCount = (this.allVotesCount === 0) ? 1 : this.allVotesCount;

        this.poll_data = poll_options.poll_options.map(option => ({y:  this.getVotePercentage(option.votes), label: option.description}));
    }

    public getAllVotesCount() {
        return this.allVotesCount;
    }

    public getPollData() {
        return this.poll_data;
    }

    public getVotePercentage(optionVotesCount) {
        return (optionVotesCount / this.allVotesCount).toFixed(2) * 100;
    }
}