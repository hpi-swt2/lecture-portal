import React from "react";
import { createStatisticsRootStore, initStatisticsApp, StoreProvider } from "../utils/StatisticsUtils";

const rootStore = createStatisticsRootStore();

interface IStatisticsAppProps {
    lecture_id: number,
    course_id: number,
    student_count: number,
    question_count: number,
    resolved_count: number
}

const StatisticsApp: React.FunctionComponent<IStatisticsAppProps> = ({ lecture_id, course_id, student_count, question_count, resolved_count }) => {
    rootStore.setLectureId(lecture_id);
    rootStore.setCourseId(course_id);
    rootStore.setStudentCount(student_count);
    rootStore.setQuestionCount(question_count);
    rootStore.setResolvedCount(resolved_count);
    initStatisticsApp(rootStore);

    return (
        <StoreProvider value={rootStore}>
            <div className="StatisticsApp">
            </div>
        </StoreProvider>
    )
};
export default StatisticsApp;
