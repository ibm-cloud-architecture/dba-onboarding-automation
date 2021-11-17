<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE WorkFlowDefinition SYSTEM "wfdef4.dtd">
<WorkFlowDefinition ApiVersion="4.0"
Origin="JavaAPI"
	Subject="&quot;&quot;"
	Name="ICNSequentialDocumentApproval"
	DisableEmailNotification="false"
	MainAttachment="&quot;DocumentforReview&quot;"
	Tag="&quot;ICNSequential&quot; + ICN_TeamspaceId"
	AuthorTool="Process Designer"
	OtherAuthorTools=""
	versionAgnostic="false"
	validateUsingSchema="true"
	validateFlag="true"
	transferFlag="true">
	<Field
		Name="Approvers"
		Description=""
		ValueExpr="{&quot;&quot;}"
		Type="participant"
		IsArray="true"
		MergeType="AppendNoDup"/>
	<Field
		Name="CurrentApprover"
		Description=""
		ValueExpr="{&quot;&quot;}"
		Type="participant"
		IsArray="true"
		MergeType="AppendNoDup"/>
	<Field
		Name="CurrentApproverIndex"
		ValueExpr="1"
		Type="int"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="DeadlineInMins"
		ValueExpr="0"
		Type="int"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="NoDeadline"
		ValueExpr="stringtotime(&quot;9999/12/31 00:00:00&quot;, &quot;yyyy/mm/dd hh:tt:ss&quot;)"
		Type="time"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="DocumentforReview"
		ValueExpr="&quot;||0|0||&quot;"
		Type="attachment"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="FinalReview"
		ValueExpr="true"
		Type="boolean"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="ReturnToSender"
		ValueExpr="true"
		Type="boolean"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="ICN_AllowReassign"
		ValueExpr="false"
		Type="boolean"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="ICN_Instructions"
		ValueExpr="&quot;&quot;"
		Type="string"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="ICN_WFDeadlineDate"
		ValueExpr="stringtotime(&quot;9999/12/31 00:00:00&quot;, &quot;yyyy/mm/dd hh:tt:ss&quot;)"
		Type="time"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="ApproverCount"
		ValueExpr="0"
		Type="int"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="Errors"
		ValueExpr="{&quot;&quot;}"
		Type="string"
		IsArray="true"
		MergeType="override"/>
	<Field
		Name="F_Trackers"
		ValueExpr="{&quot;&quot;}"
		Type="participant"
		IsArray="true"
		MergeType="default"/>
	<Field
		Name="References"
		ValueExpr="{&quot;||0|0||&quot;}"
		Type="attachment"
		IsArray="true"
		MergeType="AppendNoDup"/>
	<Field
		Name="ICN_TeamspaceId"
		ValueExpr="&quot;&quot;"
		Type="string"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="StartTime"
		ValueExpr="systemtime()"
		Type="time"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="EndDateMinuteOffset"
		ValueExpr="0"
		Type="int"
		IsArray="false"
		MergeType="override"/>
	<Field
		Name="EndDateSecondOffset"
		ValueExpr="0"
		Type="int"
		IsArray="false"
		MergeType="override"/>
	<Map
		Name="Workflow"
		MaxStepId="50" >
		<Step
			StepId="0"
			Name="Launch"
			XCoordinate="152"
			YCoordinate="103"
			RequestedInterface="Navigator Launch Pattern Processor"
			JoinType="none"
			SplitType="or"
			CanReassign="true"
			CanViewStatus="true"
			CanViewHistory="false"
			IgnoreInvalidUsers="false">
			<Parameter
				Name="Approvers"
				Description=""
				ValueExpr="Approvers"
				Type="participant"
				IsArray="true"
				Mode="inout"/>
			<Parameter
				Name="FinalReview"
				ValueExpr="FinalReview"
				Type="boolean"
				IsArray="false"
				Mode="inout"/>
			<Parameter
				Name="ReturnToSender"
				ValueExpr="ReturnToSender"
				Type="boolean"
				IsArray="false"
				Mode="inout"/>
			<Parameter
				Name="ICN_AllowReassign"
				ValueExpr="ICN_AllowReassign"
				Type="boolean"
				IsArray="false"
				Mode="inout"/>
			<Parameter
				Name="ICN_Instructions"
				ValueExpr="ICN_Instructions"
				Type="string"
				IsArray="false"
				Mode="inout"/>
			<Parameter
				Name="DocumentforReview"
				ValueExpr="DocumentforReview"
				Type="attachment"
				IsArray="false"
				Mode="inout"/>
			<Parameter
				Name="ICN_TeamspaceId"
				ValueExpr="ICN_TeamspaceId"
				Type="string"
				IsArray="false"
				Mode="inout"/>
			<Parameter
				Name="References"
				ValueExpr="References"
				Type="attachment"
				IsArray="true"
				Mode="inout"/>
			<Parameter
				Name="ICN_WFDeadlineDate"
				ValueExpr="ICN_WFDeadlineDate"
				Type="time"
				IsArray="false"
				Mode="inout"/>
			<Route
				SourceStepId="0"
				DestinationStepId="50"
				RouteId="25"
				Name="Err"
				Condition="elementcount(Errors) &gt; 0">
				<ModelAttributes>
					<ModelAttribute
						Name="UI_RouteWeight"
						Type="int"
						IsArray="false">
							<Value Val="5"/>
					</ModelAttribute>
				</ModelAttributes>
			</Route>
			<Route
				SourceStepId="0"
				DestinationStepId="30"
				RouteId="16"
				Name="Launch">
				<ModelAttributes>
					<ModelAttribute
						Name="UI_RouteWeight"
						Type="int"
						IsArray="false">
							<Value Val="95"/>
					</ModelAttribute>
				</ModelAttributes>
			</Route>
			<PostAssignments>
			<Assign LVal="ApproverCount" RVal="elementcount(Approvers)" />
			<Assign LVal="StartTime" RVal="F_StartTime" />
			<Assign LVal="EndDateMinuteOffset" RVal="days_between(ICN_WFDeadlineDate, StartTime) * 24 * 60" />
			<Assign LVal="EndDateSecondOffset" RVal="seconds_between(ICN_WFDeadlineDate, addminutes(StartTime, EndDateMinuteOffset))" />
			<Assign LVal="DeadlineInMins" RVal="if (ApproverCount=0 or ICN_WFDeadlineDate = NoDeadline, 0, (EndDateMinuteOffset + int(EndDateSecondOffset / 60)))" />
			<Assign LVal="F_WFDeadline" RVal="if (DeadlineInMins &gt; 0, DeadlineInMins, 0)" />
			<Assign LVal="Errors[1]" RVal="if (ApproverCount=0, &quot;E_NO_APPROVER&quot;, &quot;&quot;)" />
			<Assign LVal="Errors[2]" RVal="if (DeadlineInMins &lt; 0, &quot;E_NEG_DEADLINE&quot;, &quot;&quot;)" />
			</PostAssignments>
			<ModelAttributes>
				<ModelAttribute
					Name="UI_StepType"
					Type="int"
					IsArray="false">
						<Value Val="1"/>
				</ModelAttribute>
			</ModelAttributes>
		</Step>
		<Step
			StepId="9"
			Name="Review"
			Description=""
			XCoordinate="627"
			YCoordinate="103"
			RequestedInterface="Navigator Step Pattern Processor"
			QueueName="Inbox"
			Deadline="if (DeadlineInMins&gt;0,  ICN_WFDeadlineDate, NoDeadline)"
			JoinType="or"
			SplitType="or"
			CanReassign="true"
			CanViewStatus="true"
			CanViewHistory="true"
			IgnoreInvalidUsers="false">
			<Participant Val="CurrentApprover" />
			<Response Val="Approve" />
			<Response Val="Reject" />
			<Parameter
				Name="ICN_AllowReassign"
				ValueExpr="ICN_AllowReassign"
				Type="boolean"
				IsArray="false"
				Mode="in"/>
			<Parameter
				Name="ICN_Instructions"
				ValueExpr="ICN_Instructions"
				Type="string"
				IsArray="false"
				Mode="in"/>
			<Parameter
				Name="DocumentforReview"
				ValueExpr="DocumentforReview"
				Type="attachment"
				IsArray="false"
				Mode="in"/>
			<Parameter
				Name="References"
				ValueExpr="References"
				Type="attachment"
				IsArray="true"
				Mode="inout"/>
			<Route
				SourceStepId="9"
				DestinationStepId="45"
				RouteId="22"
				Name="Reject"
				Condition="ANY(Reject)">
				<ModelAttributes>
					<ModelAttribute
						Name="UI_RouteWeight"
						Type="int"
						IsArray="false">
							<Value Val="50"/>
					</ModelAttribute>
				</ModelAttributes>
			</Route>
			<Route
				SourceStepId="9"
				DestinationStepId="30"
				RouteId="17"
				Name="Approve"
				Condition="ANY(Approve) and CurrentApproverIndex &lt;= sizeof(Approvers)">
				<ModelAttributes>
					<ModelAttribute
						Name="UI_RouteWeight"
						Type="int"
						IsArray="false">
							<Value Val="35"/>
					</ModelAttribute>
				</ModelAttributes>
			</Route>
			<Route
				SourceStepId="9"
				DestinationStepId="21"
				RouteId="12"
				Name="Final Reivew"
				Condition="FinalReview = true">
				<ModelAttributes>
					<ModelAttribute
						Name="UI_RouteWeight"
						Type="int"
						IsArray="false">
							<Value Val="10"/>
					</ModelAttribute>
				</ModelAttributes>
			</Route>
			<Route
				SourceStepId="9"
				DestinationStepId="43"
				RouteId="21"
				Name="No Final Review">
				<ModelAttributes>
					<ModelAttribute
						Name="UI_RouteWeight"
						Type="int"
						IsArray="false">
							<Value Val="5"/>
					</ModelAttribute>
				</ModelAttributes>
			</Route>
			<PostAssignments>
			<Assign LVal="CurrentApproverIndex" RVal="CurrentApproverIndex + 1" />
			</PostAssignments>
			<ModelAttributes>
				<ModelAttribute
					Name="UI_StepType"
					Type="int"
					IsArray="false">
						<Value Val="2"/>
				</ModelAttribute>
			</ModelAttributes>
		</Step>
		<Step
			StepId="19"
			Name="Rework"
			XCoordinate="390"
			YCoordinate="221"
			RequestedInterface="Navigator Step Pattern Processor"
			QueueName="Inbox"
			Deadline="0"
			JoinType="or"
			SplitType="or"
			CanReassign="false"
			CanViewStatus="true"
			CanViewHistory="true"
			IgnoreInvalidUsers="false">
			<Participant Val="F_Originator" />
			<Parameter
				Name="DocumentforReview"
				ValueExpr="DocumentforReview"
				Type="attachment"
				IsArray="false"
				Mode="in"/>
			<Parameter
				Name="References"
				ValueExpr="References"
				Type="attachment"
				IsArray="true"
				Mode="inout"/>
			<Route
				SourceStepId="19"
				DestinationStepId="30"
				RouteId="18"
				Name="Resubmit">
				<ModelAttributes>
					<ModelAttribute
						Name="UI_RouteWeight"
						Type="int"
						IsArray="false">
							<Value Val="50"/>
					</ModelAttribute>
				</ModelAttributes>
			</Route>
			<PostAssignments>
			<Assign LVal="CurrentApproverIndex" RVal="1" />
			</PostAssignments>
			<ModelAttributes>
				<ModelAttribute
					Name="UI_StepType"
					Type="int"
					IsArray="false">
						<Value Val="2"/>
				</ModelAttribute>
			</ModelAttributes>
		</Step>
		<Step
			StepId="21"
			Name="Approval Notification"
			XCoordinate="809"
			YCoordinate="52"
			RequestedInterface="Navigator Step Pattern Processor"
			QueueName="Inbox"
			JoinType="or"
			SplitType="or"
			CanReassign="false"
			CanViewStatus="true"
			CanViewHistory="true"
			IgnoreInvalidUsers="false">
			<Participant Val="F_Originator" />
			<Parameter
				Name="DocumentforReview"
				ValueExpr="DocumentforReview"
				Type="attachment"
				IsArray="false"
				Mode="in"/>
			<Parameter
				Name="References"
				ValueExpr="References"
				Type="attachment"
				IsArray="true"
				Mode="in"/>
			<ModelAttributes>
				<ModelAttribute
					Name="UI_StepType"
					Type="int"
					IsArray="false">
						<Value Val="2"/>
				</ModelAttribute>
			</ModelAttributes>
		</Step>
		<CompoundStep
			StepId="30"
			Name="Assign"
			XCoordinate="290"
			YCoordinate="103"
			JoinType="or"
			SplitType="or">
			<Instruction
				Id="31"
				Action="assign">
				<Expression Val="CurrentApprover" />
				<Expression Val="{ Approvers[CurrentApproverIndex] }" />
			</Instruction>
			<Route
				SourceStepId="30"
				DestinationStepId="9"
				RouteId="19"
				Name="Assign">
				<ModelAttributes>
					<ModelAttribute
						Name="UI_RouteWeight"
						Type="int"
						IsArray="false">
							<Value Val="100"/>
					</ModelAttribute>
				</ModelAttributes>
			</Route>
			<ModelAttributes>
				<ModelAttribute
					Name="UI_IconName"
					Type="string"
					IsArray="false">
						<Value Val="filenet/vw/toolkit/utils/images/assign_step"/>
				</ModelAttribute>
				<ModelAttribute
					Name="UI_StepType"
					Type="int"
					IsArray="false">
						<Value Val="6"/>
				</ModelAttribute>
				<ModelAttribute
					Name="UI_StartIconName"
					Type="string"
					IsArray="false">
						<Value Val="filenet/vw/toolkit/utils/images/start_assign_step"/>
				</ModelAttribute>
				<ModelAttribute
					Name="UI_StepPropertiesPanelClass"
					Type="string"
					IsArray="false">
						<Value Val="filenet.vw.toolkit.design.property.steps.systeminstructions.VWAssignPropertiesPanel"/>
				</ModelAttribute>
			</ModelAttributes>
		</CompoundStep>
		<Step
			StepId="43"
			Name="Final"
			XCoordinate="809"
			YCoordinate="158"
			RequestedInterface="Navigator Step Pattern Processor"
			JoinType="or"
			SplitType="or"
			CanReassign="true"
			CanViewStatus="true"
			CanViewHistory="true"
			IgnoreInvalidUsers="false">
			<Parameter
				Name="DocumentforReview"
				ValueExpr="DocumentforReview"
				Type="attachment"
				IsArray="false"
				Mode="in"/>
			<Parameter
				Name="References"
				ValueExpr="References"
				Type="attachment"
				IsArray="true"
				Mode="in"/>
			<ModelAttributes>
				<ModelAttribute
					Name="UI_StepType"
					Type="int"
					IsArray="false">
						<Value Val="2"/>
				</ModelAttribute>
			</ModelAttributes>
		</Step>
		<CompoundStep
			StepId="45"
			Name="StepBack"
			XCoordinate="547"
			YCoordinate="221"
			JoinType="or"
			SplitType="or">
			<Instruction
				Id="46"
				Action="assign">
				<Expression Val="CurrentApproverIndex" />
				<Expression Val="CurrentApproverIndex - 2" />
			</Instruction>
			<Route
				SourceStepId="45"
				DestinationStepId="19"
				RouteId="23"
				Name="To Sender"
				Condition="ReturnToSender = true or CurrentApproverIndex &lt;= 0">
				<ModelAttributes>
					<ModelAttribute
						Name="UI_RouteWeight"
						Type="int"
						IsArray="false">
							<Value Val="80"/>
					</ModelAttribute>
				</ModelAttributes>
			</Route>
			<Route
				SourceStepId="45"
				DestinationStepId="30"
				RouteId="24"
				Name="To Previous">
				<ModelAttributes>
					<ModelAttribute
						Name="UI_RouteWeight"
						Type="int"
						IsArray="false">
							<Value Val="20"/>
					</ModelAttribute>
				</ModelAttributes>
			</Route>
			<ModelAttributes>
				<ModelAttribute
					Name="UI_IconName"
					Type="string"
					IsArray="false">
						<Value Val="filenet/vw/toolkit/utils/images/assign_step"/>
				</ModelAttribute>
				<ModelAttribute
					Name="UI_StepType"
					Type="int"
					IsArray="false">
						<Value Val="6"/>
				</ModelAttribute>
				<ModelAttribute
					Name="UI_StartIconName"
					Type="string"
					IsArray="false">
						<Value Val="filenet/vw/toolkit/utils/images/start_assign_step"/>
				</ModelAttribute>
				<ModelAttribute
					Name="UI_StepPropertiesPanelClass"
					Type="string"
					IsArray="false">
						<Value Val="filenet.vw.toolkit.design.property.steps.systeminstructions.VWAssignPropertiesPanel"/>
				</ModelAttribute>
			</ModelAttributes>
		</CompoundStep>
		<Step
			StepId="50"
			Name="Error"
			XCoordinate="291"
			YCoordinate="220"
			RequestedInterface="Navigator Step Pattern Processor"
			QueueName="Inbox"
			JoinType="or"
			SplitType="or"
			CanReassign="true"
			CanViewStatus="true"
			CanViewHistory="true"
			IgnoreInvalidUsers="false">
			<Participant Val="F_Originator" />
			<Parameter
				Name="Errors"
				ValueExpr="Errors"
				Type="string"
				IsArray="true"
				Mode="in"/>
			<Parameter
				Name="DocumentforReview"
				ValueExpr="DocumentforReview"
				Type="attachment"
				IsArray="false"
				Mode="in"/>
			<Parameter
				Name="References"
				ValueExpr="References"
				Type="attachment"
				IsArray="true"
				Mode="in"/>
			<ModelAttributes>
				<ModelAttribute
					Name="UI_StepType"
					Type="int"
					IsArray="false">
						<Value Val="2"/>
				</ModelAttribute>
			</ModelAttributes>
		</Step>
	</Map>
</WorkFlowDefinition>
