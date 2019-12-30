import {QuestionModel} from "./Question";

export enum UpdateTypes {
    Question, Poll
}

export class UpdateItem {
    id: string;
    constructor(readonly type: UpdateTypes, readonly item: (QuestionModel | any)) {
        this.id = type + "-" + item.value.id
    }
    getTitle(): string {
        switch(this.type) {
            case(UpdateTypes.Question): {
                return "Question";
            }
        }
    }
    getContent(): string {
        switch(this.type) {
            case(UpdateTypes.Question): {
                return (this.item.value as QuestionModel).content;
            }
        }
    }
    onClick() {
        switch(this.type) {
            case(UpdateTypes.Question): {
                (this.item.value as QuestionModel).resolveClick();
                break;
            }
        }
    }
}