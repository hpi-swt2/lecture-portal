import React from "react";
import {observer} from "mobx-react";
import {useInjectStatistics} from "../hooks/useInject";
import {StatisticsRootStoreModel} from "../stores/StatisticsRootStore";

const mapStore = ({ student_count, question_count, resolved_count }: StatisticsRootStoreModel) => ({
    student_count,
    question_count,
    resolved_count
});

const StatisticsView: React.FunctionComponent<{}> = observer(() => {
    const { student_count, question_count, resolved_count } = useInjectStatistics(mapStore);

    return (
        <div className="row">
            <div className="col col-sm-6">
                <div className="statistics-box">
                    <p>Students</p>
                    <p>{student_count}</p>
                </div>
            </div>
            <div className="col col-sm-6">
                <div className="statistics-box">
                    <p>Resolved Questions</p>
                    <p>{resolved_count}/{question_count}</p>
                </div>
            </div>
        </div>
    );
});

export default StatisticsView;
