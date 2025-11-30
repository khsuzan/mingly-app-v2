class BuyPlanForm {
  final String membershipId;
  final String membershipTier;
  final String? checkoutUrl;

  BuyPlanForm({
    required this.membershipId,
    required this.membershipTier,
    this.checkoutUrl,
  });

  factory BuyPlanForm.fromJson(Map<String, dynamic> json) {
    return BuyPlanForm(
      membershipId: json['membership_id'] as String,
      membershipTier: json['membership_tier'] as String,
      checkoutUrl: json['checkout_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membership_id': membershipId,
      'membership_tier': membershipTier,
      if (checkoutUrl != null) 'checkout_url': checkoutUrl,
    };
  }

  BuyPlanForm copyWith({
    String? membershipId,
    String? membershipTier,
    String? checkoutUrl,
  }) {
    return BuyPlanForm(
      membershipId: membershipId ?? this.membershipId,
      membershipTier: membershipTier ?? this.membershipTier,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
    );
  }

  @override
  String toString() =>
      'BuyPlanForm(membershipId: $membershipId, membershipTier: $membershipTier, checkoutUrl: $checkoutUrl)';
}

class BuyPlanResponse {
  final String checkoutUrl;

  BuyPlanResponse({required this.checkoutUrl});

  factory BuyPlanResponse.fromJson(Map<String, dynamic> json) {
    return BuyPlanResponse(
      checkoutUrl: json['checkout_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkout_url': checkoutUrl,
    };
  }

  @override
  String toString() => 'BuyPlanResponse(checkoutUrl: $checkoutUrl)';
}