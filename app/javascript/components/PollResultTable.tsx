import React from "react";
import { observer } from "mobx-react";
import { PollOptionsRootStoreModel } from "../stores/PollOptionsRootStore";
import {useInjectPollOptions} from "../hooks/useInject";

const mapStore = ({ poll_options }: PollOptionsRootStoreModel) => ({
    poll_options
});

const PollResultTable: React.FunctionComponent<{}> = observer(() => {
    const { poll_options } = useInjectPollOptions(mapStore);
    const allVotes = poll_options.poll_options.map(option => option.votes).reduce((a, b) => a + b, 0);

        return (
            <table className="table .table-sm table-striped">
                <thead>
                    <tr>
                        <th>Description</th>
                        <th className="text-right">Votes</th>
                        <th className="text-right">Percentage</th>
                    </tr>
                </thead>

                <tbody>
                {poll_options.poll_options.map(option => (
                    <tr>
                        <td>{option.description}</td>
                        <td className="text-right">{option.votes}</td>
                        <td className="text-right"> {(option.votes / allVotes).toFixed(2)}</td>
                    </tr>
                ))}
                </tbody>
            </table>
        );
});

export default PollResultTable;