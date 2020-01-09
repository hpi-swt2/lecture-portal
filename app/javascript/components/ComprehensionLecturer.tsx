import React from "react";
import { observer } from "mobx-react";
import {ComprehensionRootStoreModel} from "../stores/ComprehensionRootStore";
import {useInjectComprehension} from "../hooks/useInject";

const mapStore = ({ is_student }: ComprehensionRootStoreModel) => ({
    is_student
});

const ComprehensionLecturer: React.FunctionComponent<{}> = observer(() => {
    const { is_student } = useInjectComprehension(mapStore);

    return (
        <div />
    );
});

export default ComprehensionLecturer
