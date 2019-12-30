import {PollOptionModel} from "./PollOption";

export enum UpdateTypes {
    PollOption, Poll
}

export class UpdatePollOption {
    id: string;
    constructor(readonly type: UpdateTypes, readonly pollOption: (PollOptionModel | any)) {
        this.id = type + "-" + pollOption.value.id
    }
    getTitle(): string {
        switch(this.type) {
            case(UpdateTypes.PollOption): {
                return "PollOption";
            }
        }
    }
    getDescription(): string {
        switch(this.type) {
            case(UpdateTypes.PollOption): {
                return (this.pollOption.value as PollOptionModel).description;
            }
        }
    }
    getVotes(): number {
        switch(this.type) {
            case(UpdateTypes.PollOption): {
                return (this.pollOption.value as PollOptionModel).votes;
            }
        }
    }
}