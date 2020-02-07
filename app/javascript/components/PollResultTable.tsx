import React from "react";
import { observer } from "mobx-react";
import { PollOptionsRootStoreModel } from "../stores/PollOptionsRootStore";
import {useInjectPollOptions} from "../hooks/useInject";
import PollResultDataInitializer from "./PollResultDataInitializer";

const mapStore = ({ poll_options }: PollOptionsRootStoreModel) => ({
    poll_options
});

const PollResultTable: React.FunctionComponent<{}> = observer(() => {
    const { poll_options } = useInjectPollOptions(mapStore);
    const pollDataInitializer = new PollResultDataInitializer(poll_options);

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
                        <td className="text-right"> {pollDataInitializer.getVotePercentage(option.votes)} %</td>
                    </tr>
                ))}
                </tbody>
            </table>
        );
});

export default PollResultTable;